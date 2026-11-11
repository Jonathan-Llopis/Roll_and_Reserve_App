# Issue 05: Fuga de Memoria en Listener de Enlaces Profundos y Carga Segura de `.env`

- **Identificador**: 
- **GitHub Issue**: [#38](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/38)`ISSUE-05`
- **Prioridad**: 🟡 Media (Eficiencia de Memoria y Robustez en Inicialización)
- **Impacto**: Eliminación de fugas de recursos y prevención de fallos al iniciar la aplicación.

---

## 1. Resumen del Por Qué

1. **Fuga de Memoria en Stream**:
   En [lib/main.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/main.dart#L73-L83):
   ```dart
   void _initDeepLinkListener() async {
     _appLinks = AppLinks();
     _appLinks.uriLinkStream.listen((Uri? uri) { ... });
   }
   ```
   La suscripción que devuelve `uriLinkStream.listen` no se almacena en ninguna variable y `MyAppState` no implementa el método `dispose()`. Si el widget se reconstruye o se reinicia el ciclo de vida, el listener queda flotando en memoria indefinidamente con referencias vivas al router.
2. **Crash al Iniciar sin `.env`**:
   En la línea 32 de `main.dart`:
   ```dart
   await dotenv.load(fileName: '.env');
   ```
   Si el archivo `.env` no existe o no se incluye como asset (problema que arrojó `flutter analyze`), la aplicación aborta antes de arrancar la interfaz gráfica.

---

## 2. Solución Propuesta

1. Guardar la suscripción de `AppLinks` y cancelarla en `dispose()`:
   ```dart
   class MyAppState extends State<MyApp> {
     late final AppLinks _appLinks;
     StreamSubscription<Uri?>? _linkSubscription;

     @override
     void initState() {
       super.initState();
       _initDeepLinkListener();
     }

     void _initDeepLinkListener() {
       _appLinks = AppLinks();
       _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
         if (uri != null && mounted) {
           final path = uri.path.replaceAll(RegExp(r'/\d+$'), '');
           router.go(path, extra: uri.queryParameters);
         }
       });
     }

     @override
     void dispose() {
       _linkSubscription?.cancel();
       super.dispose();
     }
   ```
2. Cargar `.env` con control de excepciones y fallback seguro:
   ```dart
   try {
     await dotenv.load(fileName: '.env');
   } catch (e) {
     debugPrint('Advertencia: No se pudo cargar el archivo .env ($e). Se utilizarán valores predeterminados.');
   }
   ```

---

## 3. Pruebas y Verificación

- **Prueba de Ciclo de Vida**: `test/main_lifecycle_test.dart`:
  - Montar `MyApp`, desmontar el widget con `tester.pumpWidget(Container())` y verificar que la suscripción sea liberada sin emitir errores de memoria.
- **Comando de ejecución**:
  ```bash
  flutter test test/main_lifecycle_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] La suscripción de `AppLinks` se cancela de manera determinista en `dispose()`.
- [ ] La app arranca limpiamente sin crashear en entornos donde `.env` deba inicializarse por variables del sistema.
