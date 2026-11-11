# Issue 11: Refactorización de Inyección de Dependencias a Parámetros Nombrados y Módulos

- **Identificador**: 
- **GitHub Issue**: [#40](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/40)`ISSUE-11`
- **Prioridad**: 🔴 Alta (Seguridad en Tiempo de Ejecución y Mantenibilidad)
- **Impacto**: Eliminación de errores de inyección silenciosos y organización del Service Locator.

---

## 1. Resumen del Por Qué

En [lib/injection.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/injection.dart#L110-L173), la inyección de dependencias de los BLoCs se realiza mediante extensas listas de argumentos posicionales no tipados explícitamente:
```dart
sl.registerFactory<ReserveBloc>(
  () => ReserveBloc(
    sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(),
    sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(),
  ),
);
```
Si se modifica la firma del constructor de cualquier BLoC, el compilador puede asociar una instancia de tipo compatible en la posición equivocada sin emitir advertencias hasta que la aplicación crashea en runtime.

---

## 2. Solución Propuesta

1. Convertir los constructores de todos los BLoCs para que requieran **parámetros nombrados**:
   ```dart
   ReservationBloc({
     required this.createReserveUseCase,
     required this.getReserveUseCase,
     required this.deleteReserveUseCase,
   });
   ```
2. Reorganizar `lib/injection.dart` dividiendo el registro en funciones modulares agrupadas por dominio:
   - `lib/config/di/di_core.dart`
   - `lib/config/di/di_auth.dart`
   - `lib/config/di/di_shops.dart`
   - `lib/config/di/di_reservations.dart`
   - `lib/config/di/di_chat.dart`
3. Registrar con resolución de tipo explícito en GetIt:
   ```dart
   sl.registerFactory<ReservationBloc>(
     () => ReservationBloc(
       createReserveUseCase: sl<CreateReserveUseCase>(),
       getReserveUseCase: sl<GetAllReservesUseCase>(),
       deleteReserveUseCase: sl<DeleteReserveUseCase>(),
     ),
   );
   ```

---

## 3. Pruebas y Verificación

- **Prueba de Inyección Completa**: `test/injection_test.dart`:
  - Inicializar `configureDependencies()`.
  - Asegurar que todas las factorías y singletons se instancien correctamente.
- **Comando de ejecución**:
  ```bash
  flutter test test/injection_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] Cero llamadas posicionales `sl(), sl()` en la inyección de dependencias.
- [ ] Todos los BLoCs utilizan parámetros nombrados obligatorios (`required`).
- [ ] La inyección queda dividida en módulos limpios y legibles.
