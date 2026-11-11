# Issue 04: Erradicación de `Navigator.push` Bypasseando GoRouter y Registro de Rutas Faltantes

- **Identificador**: 
- **GitHub Issue**: [#37](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/37)`ISSUE-04`
- **Prioridad**: 🔴 Alta (Integridad de Enrutamiento y Deep Linking)
- **Impacto**: Coherencia en Web y Móvil, enlaces profundos, historial de navegación unificado.

---

## 1. Resumen del Por Qué

El proyecto especifica en `GEMINI.md`:
> *"Navigation: `go_router` - Declarative routing."*

Sin embargo, múltiples pantallas y widgets esquivan el sistema declarativo mediante llamadas imperativas clásicas a `Navigator.push`:
- [lib/presentation/widgets/screen_components/drawer_main.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/widgets/screen_components/drawer_main.dart#L164): Abre `ScreenReviewUser` usando `Navigator.push(context, PageRouteBuilder(...))`.
- [lib/presentation/widgets/screen_components/screen_body/body_reserves_table.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/widgets/screen_components/screen_body/body_reserves_table.dart#L184): Hace push imperativo de `ScreenReserve`.
- [lib/presentation/widgets/screen_components/screen_body/body_reserves_user.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/widgets/screen_components/screen_body/body_reserves_user.dart#L63): Hace push imperativo de `ScreenReserve`.
- [lib/presentation/screens/screen_reserve.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/screens/screen_reserve.dart#L147): Abre `ScreenQr` con `Navigator.push`.
- [lib/presentation/screens/screen_event.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/screens/screen_event.dart#L100): Abre `ScreenQr` con `Navigator.push`.

### Consecuencias Negativas:
1. Las pantallas `ScreenReviewUser`, `ScreenReserve` y `ScreenQr` ni siquiera están registradas en [lib/config/router/routes.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/config/router/routes.dart).
2. Es imposible acceder a una reserva o escanear un QR mediante enlaces profundos (deep links).
3. En Flutter Web, la barra del navegador no cambia de URL y el botón atrás del navegador rompe la navegación.
4. Se eluden por completo los guardas de seguridad y redirección definidos en el router.

---

## 2. Solución Propuesta

1. Registrar las rutas faltantes en `routes.dart`:
   ```dart
   GoRoute(
     name: 'userReviews',
     path: '/reviews/user',
     pageBuilder: (context, state) => CustomTransitionPage(
       key: state.pageKey,
       child: ScreenReviewUser(appBar: appBar),
       transitionsBuilder: (context, a, sa, child) => child,
     ),
   ),
   GoRoute(
     name: 'reserveDetail',
     path: '/reserves/detail/:idReserve',
     pageBuilder: (context, state) {
       final idReserve = int.tryParse(state.pathParameters['idReserve'] ?? '') ?? 0;
       return CustomTransitionPage(
         key: state.pageKey,
         child: ScreenReserve(idReserve: idReserve, appBar: appBar),
         transitionsBuilder: (context, a, sa, child) => child,
       );
     },
   ),
   GoRoute(
     name: 'reserveQr',
     path: '/reserves/qr/:idReserve',
     pageBuilder: (context, state) {
       final idReserve = int.tryParse(state.pathParameters['idReserve'] ?? '') ?? 0;
       return CustomTransitionPage(
         key: state.pageKey,
         child: ScreenQr(idReserve: idReserve),
         transitionsBuilder: (context, a, sa, child) => child,
       );
     },
   ),
   ```
2. Reemplazar todas las llamadas imperativas `Navigator.push(...)` por `context.pushNamed(...)` o `context.goNamed(...)`.

---

## 3. Pruebas y Verificación

- **Pruebas de Widgets y Navegación**:
  - `test/presentation/navigation_test.dart`:
    - Simular tap en el botón de reseñas del drawer $\rightarrow$ Verificar llamada a GoRouter hacia `/reviews/user`.
    - Simular selección de tarjeta de reserva $\rightarrow$ Verificar navegación GoRouter hacia `/reserves/detail/:idReserve`.
- **Comando de ejecución**:
  ```bash
  flutter test test/presentation/navigation_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] Cero ocurrencias de `Navigator.push` en todo el proyecto.
- [ ] `ScreenReviewUser`, `ScreenReserve` y `ScreenQr` forman parte oficial de las rutas declarativas.
- [ ] La navegación funciona con URLs limpias y soporta enlaces profundos directos.
