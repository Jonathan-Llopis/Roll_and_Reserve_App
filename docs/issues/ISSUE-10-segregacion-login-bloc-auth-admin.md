# Issue 10: Segregación de Responsabilidades en `LoginBloc` (Auth vs UserProfile vs Admin)

- **Identificador**: `ISSUE-10`
- **GitHub Issue**: [#17 Decompose LoginBloc into AuthBloc and UserBloc](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/17)
- **Prioridad**: 🔴 Alta (Seguridad en Separación de Roles y Limpieza de Estado)
- **Impacto**: Aislamiento de privilegios de administrador y simplificación del ciclo de autenticación.

---

## 1. Resumen del Por Qué

[lib/presentation/blocs/login/login_bloc.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/blocs/login/login_bloc.dart#L20-L50):
Aunque se llama `LoginBloc`, concentra **13 dependencias** y maneja:
1. Autenticación (Email, Google, Registro, Cierre de sesión, Recuperación de contraseña).
2. Perfil de usuario (Actualizar datos, subir avatar, validar contraseña actual).
3. Administración global (Consulta de todos los usuarios del sistema `getAllUsersUseCase`).

### Riesgo de Seguridad y Arquitectura:
- Mezclar lógica de acceso administrativo dentro del BLoC de login de usuario común es una violación de separación de privilegios.
- El estado `LoginState` mezcla campos como `validatePassword`, `isEmailUsed`, `users` (lista de todos los usuarios del sistema) y tokens en un mismo contenedor.

---

## 2. Solución Propuesta

1. Segregar `LoginBloc` en tres componentes:
   - `AuthBloc`: Control del ciclo de vida de la sesión (no autenticado, autenticando, autenticado, error de credenciales).
   - `UserProfileBloc`: Gestión de datos personales del usuario conectado, cambio de avatar y actualización de contraseñas.
   - `AdminUserBloc`: Operaciones exclusivas del panel de administración (obtención de lista global de usuarios y modificación de roles).
2. Proveer `AdminUserBloc` únicamente en las rutas y pantallas que exijan rol administrativo (`role == 0`).

---

## 3. Pruebas y Verificación

- **Pruebas de BLoC**:
  - `test/presentation/blocs/auth/auth_bloc_test.dart`: Evaluar transiciones de autenticación y cierre de sesión.
  - `test/presentation/blocs/admin/admin_user_bloc_test.dart`: Verificar la carga protegida de usuarios.
- **Comando de ejecución**:
  ```bash
  flutter test test/presentation/blocs/
  ```

---

## 4. Criterios de Aceptación

- [ ] `AuthBloc` se encarga exclusivamente del inicio/cierre de sesión y estado de autenticación.
- [ ] La consulta de todos los usuarios del sistema queda restringida a `AdminUserBloc`.
- [ ] La gestión de perfil no interfiere con el estado de la sesión activa.
