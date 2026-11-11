# Issue 18: Migración de Credenciales y Tokens a Almacenamiento Seguro (`flutter_secure_storage`)

- **Identificador**: `ISSUE-18`
- **GitHub Issue**: [#19 Security: Migrate sensitive credentials from SharedPreferences to Secure Storage](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/19)
- **Prioridad**: 🔴 Alta (Seguridad de Datos y Cumplimiento OWASP)
- **Impacto**: Cifrado de tokens JWT y credenciales de sesión en hardware seguro (Android Keystore / iOS Keychain).

---

## 1. Resumen del Por Qué

Actualmente, los tokens de autenticación JWT y credenciales de usuario se persisten en texto plano mediante `SharedPreferences`:
- En Android, `SharedPreferences` almacena los datos en archivos XML sin cifrar dentro del sandbox `/data/data/...`. En dispositivos rooteados o mediante copias de seguridad de depuración (ADB backup), estos archivos pueden ser extraídos trivialmente.
- Cualquier fuga del token JWT otorga acceso no autorizado a la cuenta del usuario en la API de Roll & Reserve.

---

## 2. Solución Propuesta

1. **Añadir `flutter_secure_storage`**:
   Incorporar la librería estándar para cifrado mediante Keystore (Android) y Keychain (iOS).
2. **Implementar `SecureTokenProvider`**:
   Extender o adaptar la interfaz `TokenProvider` creada en `ISSUE-02` para almacenar el token JWT de forma cifrada en `FlutterSecureStorage`.
3. **Mantener `SharedPreferences` Solo para Preferencias No Sensibles**:
   Utilizar `SharedPreferences` únicamente para datos no sensibles como `locale` (idioma seleccionado) y banderas de primer inicio (`isFirstTime`).

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias**:
  Crear un mock de `FlutterSecureStorage` y verificar que `TokenProvider` lee y escribe utilizando métodos cifrados (`read`, `write`, `delete`).
- **Verificación de Seguridad**:
  Comprobar que en `SharedPreferences` no queda rastro de strings con prefijos JWT (`ey...`).

---

## 4. Criterios de Aceptación

- [ ] Dependencia `flutter_secure_storage` agregada a `pubspec.yaml`.
- [ ] `TokenProvider` almacena y recupera tokens de autenticación a través de `FlutterSecureStorage`.
- [ ] Datos no sensibles (idioma, flags de interfaz) permanecen en `SharedPreferences`.
- [ ] Pruebas unitarias de almacenamiento seguro pasan con éxito.
