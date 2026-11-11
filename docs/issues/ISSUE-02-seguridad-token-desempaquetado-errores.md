# Issue 02: Eliminación de Desempaquetados Forzados `token!` y Clasificación Estricta de Errores

- **Identificador**: 
- **GitHub Issue**: [#35](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/35)`ISSUE-02`
- **Prioridad**: 🔴 Crítica (Seguridad y Resiliencia)
- **Impacto**: Prevención de cierres inesperados (crashes), diagnóstico de errores y seguridad de sesión.

---

## 1. Resumen del Por Qué

En las implementaciones de repositorios de la capa de datos (`data/repositories/`), se accede al token de sesión almacenado en `SharedPreferences` y se fuerza su desempaquetado mediante el operador `token!`:
- [lib/data/repositories/reserve_repository_impl.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/data/repositories/reserve_repository_impl.dart#L36-L45):
  ```dart
  final token = sharedPreferences.getString('token');
  final reserveModels = await remoteDataSource.getAllReserves(token!);
  ```
Este patrón inseguro se repite **más de 30 veces** en repositorios como `category_game`, `reserve`, `user`, `table`, `game` y `difficulty`.

### Riesgos Críticos:
1. **Crash en Runtime**: Si la sesión del usuario expira, el token no se guardó o las preferencias fueron eliminadas, `token!` arroja una excepción fatal `Null check operator used on a null value`.
2. **Enmascaramiento de Fallos**: El bloque genérico `catch (e)` captura el error de puntero nulo y lo transforma en un engañoso `ServerFailure('Error al cargar reservas')`. El usuario ve un error de servidor cuando en realidad su sesión ha caducado.
3. **Ceguera en UserRepository**: En [lib/data/repositories/user_repository_impl.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/data/repositories/user_repository_impl.dart), cualquier excepción (pérdida de WiFi, caída 500 del backend, timeout) se captura devolviendo ciegamente `Left(AuthFailure())`.

---

## 2. Solución Propuesta

1. Diseñar una interfaz segura `TokenProvider`:
   ```dart
   // lib/core/network/token_provider.dart
   abstract class TokenProvider {
     Future<String?> getToken();
     Future<bool> hasValidToken();
     Future<void> clearToken();
   }
   ```
2. Implementar `TokenProviderImpl` encapsulando la lectura segura de `SharedPreferences`.
3. Validar la presencia del token antes de realizar llamadas de red en cada repositorio:
   ```dart
   final token = await tokenProvider.getToken();
   if (token == null || token.trim().isEmpty) {
     return const Left(AuthFailure('Sesión expirada o no iniciada'));
   }
   ```
4. Categorizar estrictamente las excepciones en lugar de atraparlas genéricamente:
   ```dart
   } on SocketException catch (_) {
     return const Left(NetworkFailure('No hay conexión a internet'));
   } on FormatException catch (e) {
     return Left(ValidationFailure('Formato de datos devuelto no válido: ${e.message}'));
   } on HttpException catch (e) {
     return Left(ServerFailure(e.message));
   } catch (e) {
     return Left(ServerFailure('Error inesperado: $e'));
   }
   ```

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias**:
  - `test/data/repositories/reserve_repository_test.dart`:
    - Simular `tokenProvider.getToken()` retornando `null` $\rightarrow$ Verificar que el repositorio retorne `Left(AuthFailure)`.
    - Simular `remoteDataSource` lanzando `SocketException` $\rightarrow$ Verificar retorno `Left(NetworkFailure)`.
    - Simular llamada válida con token $\rightarrow$ Verificar retorno `Right(List<ReserveEntity>)`.
- **Comando de ejecución**:
  ```bash
  flutter test test/data/repositories/
  ```

---

## 4. Criterios de Aceptación

- [ ] Cero ocurrencias de `token!` en todos los archivos de `lib/data/repositories/`.
- [ ] La falta de token devuelve un `AuthFailure` formal que permite redirigir al login.
- [ ] Los errores de conexión de red devuelven `NetworkFailure`.
- [ ] Las trazas de excepción internas no se muestran directamente al usuario en textos crudos.
