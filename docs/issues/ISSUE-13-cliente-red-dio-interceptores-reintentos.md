# Issue 13: Migración a Cliente de Red Centralizado con `Dio`, Interceptores y Reintentos

- **Identificador**: `ISSUE-13`
- **GitHub Issue**: [#21 Network: Implement centralized ApiClient with interceptors, timeouts & typed exceptions](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/21)
- **Prioridad**: 🔴 Alta (Seguridad de Transporte, Eficiencia y Resiliencia)
- **Impacto**: Interceptores automáticos de token Bearer, timeouts estrictos y reintentos transparentes.

---

## 1. Resumen del Por Qué

Actualmente, cada datasource remoto (`shop_datasource`, `reserve_datasource`, `table_datasource`, `game_datasource`, `user_datasource`) realiza llamadas HTTP manuales usando `http.Client`:
- Construye URLs duplicando `Uri.parse('${dotenv.env['BACKEND']}/...')`.
- Inyecta cabeceras `Authorization: Bearer $token` a mano en cada llamada.
- Carece de política de timeouts (un corte de conexión puede colgar la petición indefinidamente).
- Carece de reintentos automáticos ante pérdidas transitorias de cobertura móvil.

### Decisión de Eficiencia y Seguridad:
Migrar a **[`dio`](https://pub.dev/packages/dio)** junto a **`dio_smart_retry`**:
- **Seguridad**: Inyección centralizada de tokens en un único interceptor (`AuthInterceptor`), evitando manipular o pasar tokens manualmente por capas intermedias.
- **Eficiencia**: Conexiones persistentes HTTP/2, control de timeouts estrictos contra ataques de denegación de servicio/cuelgues y política de reintento exponencial transparente.

---

## 2. Solución Propuesta

1. Añadir dependencias en [pubspec.yaml](file:///home/caveman/Proyectos/Roll_and_Reserve_App/pubspec.yaml):
   ```yaml
   dependencies:
     dio: ^5.7.0
     dio_smart_retry: ^6.0.0
   ```
2. Crear un `ApiClient` configurado centralizadamente:
   ```dart
   // lib/core/network/api_client.dart
   class ApiClient {
     final Dio dio;

     ApiClient({required this.dio, required TokenProvider tokenProvider}) {
       dio.options.baseUrl = dotenv.env['BACKEND'] ?? 'http://localhost:3000';
       dio.options.connectTimeout = const Duration(seconds: 15);
       dio.options.receiveTimeout = const Duration(seconds: 15);

       dio.interceptors.add(
         InterceptorsWrapper(
           onRequest: (options, handler) async {
             final token = await tokenProvider.getToken();
             if (token != null && token.isNotEmpty) {
               options.headers['Authorization'] = 'Bearer $token';
             }
             return handler.next(options);
           },
           onError: (error, handler) {
             // Tratamiento centralizado de errores 401 Unauthorized
             return handler.next(error);
           },
         ),
       );

       dio.interceptors.add(
         RetryInterceptor(
           dio: dio,
           retries: 3,
           retryDelays: const [
             Duration(seconds: 1),
             Duration(seconds: 2),
             Duration(seconds: 3),
           ],
         ),
       );
     }
   }
   ```
3. Inyectar `ApiClient` en todos los datasources de la aplicación, simplificando radicalmente su código.

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias de Red**: `test/core/network/api_client_test.dart`:
  - Verificar que el interceptor adjunte la cabecera `Authorization` cuando el token esté disponible.
  - Comprobar que una petición fallida con error 503 se reintente hasta 3 veces automáticamente.
- **Comando de ejecución**:
  ```bash
  flutter test test/core/network/
  ```

---

## 4. Criterios de Aceptación

- [ ] Todo el tráfico HTTP hacia el backend se canaliza a través de `ApiClient` con `Dio`.
- [ ] No se manipulan cabeceras ni tokens manualmente en los datasources.
- [ ] Las peticiones tienen timeout configurado para evitar bloqueos de interfaz.
- [ ] Los micro-cortes de red se gestionan con reintentos transparentes sin intervención del usuario.
