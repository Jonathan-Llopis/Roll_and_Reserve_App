# Issue 03: Corrección de Redirecciones en GoRouter (Tipos Async y Bucle de Redirección)

- **Identificador**: 
- **GitHub Issue**: [#36](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/36)`ISSUE-03`
- **Prioridad**: 🔴 Crítica (Estabilidad y Arquitectura de Navegación)
- **Impacto**: Prevención de bucles infinitos de redirección, colisiones de estado y crashes de navegación.

---

## 1. Resumen del Por Qué

El hook `redirect` en [lib/config/router/routes.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/config/router/routes.dart#L365-L396) contiene anomalías graves:
```dart
redirect: (context, state) async {
  // ...
  return isLoggedIn.fold(
    (_) => '/login',
    (loggedIn) async { // <-- ASYNC closure dentro de fold síncrono
      final sharedPreferences = await SharedPreferences.getInstance();
      final isFirstTime = sharedPreferences.getBool('isFirstTime') ?? true;
      if (isFirstTime && loggedIn.role == 1) {
        return '/ownerOnBoard';
      } else if (isFirstTime && loggedIn.role == 2) {
        return '/userOnBoard';
      } else {
        return state.matchedLocation; // <-- RETORNA la misma ubicación actual
      }
    },
  );
}
```

### Riesgos Críticos:
1. **Incompatibilidad de Tipos**: `fold` retorna `Object` (la rama izquierda retorna `String` y la derecha retorna `Future<String>`). GoRouter espera `FutureOr<String?>`.
2. **Bucle o Re-evaluación Redundante**: Retornar `state.matchedLocation` le dice a GoRouter: *"redirige de nuevo a donde ya estoy"*. GoRouter exige retornar `null` para indicar que se permite la navegación hacia la ruta pedida sin redirección adicional.
3. **Contaminación de Estado en Build**: La línea 370 ejecuta `BlocProvider.of<LoginBloc>(context).add(CheckAuthentication())`. Disparar eventos a BLoCs durante la evaluación de rutas altera el ciclo de vida del árbol de widgets provocando reconstrucciones conflictivas.
4. **Parseo No Seguro de Parámetros**: En la línea 116, `int.parse(state.pathParameters['idEditShop']!)` no está protegido. Cualquier parámetro inválido en la URL produce un crash directo por `FormatException`.

---

## 2. Solución Propuesta

1. Reestructurar el callback `redirect` de forma asíncrona limpia:
   ```dart
   redirect: (context, state) async {
     final userRepo = di.sl<UserRepository>();
     final authResult = await userRepo.isLoggedIn();
     final isGoingToLogin = state.matchedLocation.startsWith('/login');

     return authResult.fold(
       (failure) => isGoingToLogin ? null : '/login',
       (user) {
         final prefs = di.sl<SharedPreferences>();
         final isFirstTime = prefs.getBool('isFirstTime') ?? true;

         if (isFirstTime && user.role == 1) return '/ownerOnBoard';
         if (isFirstTime && user.role == 2) return '/userOnBoard';
         if (isGoingToLogin) return '/user';

         return null; // Permite acceder a la ruta destino normalmente
       },
     );
   },
   ```
2. Eliminar la emisión de eventos de BLoC desde el interior del router.
3. Sustituir `int.parse(...)!` por parseo seguro:
   ```dart
   final shopId = int.tryParse(state.pathParameters['idEditShop'] ?? '') ?? -1;
   ```

---

## 3. Pruebas y Verificación

- **Pruebas de Rutas con GoRouter**: `test/config/router/router_test.dart`:
  - Verificar que un usuario no autenticado sea redirigido a `/login`.
  - Verificar que un usuario autenticado pueda acceder a `/user` y el router retorne `null`.
  - Probar navegación a `/shop_edit/parametro_invalido` comprobando que no se produzca una excepción no capturada.
- **Comando de ejecución**:
  ```bash
  flutter test test/config/router/
  ```

---

## 4. Criterios de Aceptación

- [ ] La función `redirect` retorna exclusivamente `FutureOr<String?>` sin closures anidadas heterogéneas.
- [ ] Se devuelve `null` en lugar de `state.matchedLocation` cuando la navegación es válida.
- [ ] No se emiten eventos a ningún BLoC desde el router.
- [ ] Se validan de forma segura todos los parámetros numéricos de URL.
