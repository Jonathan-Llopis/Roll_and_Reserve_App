# Issue 16: Persistencia Local Segura con `sqflite` para Historial de IA y Sesiones de Chat

- **Identificador**: 
- **GitHub Issue**: [#44](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/44)`ISSUE-16`
- **Prioridad**: 🟢 Normal (Experiencia de Usuario y Eficiencia de Sesión)
- **Impacto**: Disponibilidad offline de recomendaciones anteriores y desacoplamiento de estado volátil.

---

## 1. Resumen del Por Qué

En [lib/data/datasources/chat_datasource.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/data/datasources/chat_datasource.dart#L26-L27):
```dart
List<Message> chatHistory = [];
List<Message> rolePlayHistory = [];
```
El historial de conversación con las IAs (DeepSeek y Google Gemini) se almacena en memoria volátil dentro de un singleton.
Si el usuario sale de la aplicación, recibe una llamada o el sistema operativo libera memoria en segundo plano, se pierden todas las consultas, explicaciones de reglas y recomendaciones de juegos generadas.

---

## 2. Solución Propuesta

1. Implementar `ChatLocalDataSource` empleando `sqflite` (que ya está presente en `pubspec.yaml`).
2. Diseñar la tabla local `chat_messages`:
   ```sql
   CREATE TABLE chat_messages (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     session_id TEXT NOT NULL,
     role TEXT NOT NULL,
     content TEXT NOT NULL,
     mode TEXT NOT NULL,
     created_at INTEGER NOT NULL
   );
   ```
3. Exponer métodos en el repositorio para:
   - Cargar el historial previo al abrir una sesión.
   - Guardar cada interacción de forma asíncrona.
   - Permitir al usuario vaciar su historial bajo demanda.

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias de Base de Datos Local**: `test/data/datasources/chat_local_datasource_test.dart`:
  - Guardar y recuperar mensajes por `session_id`.
  - Probar eliminación completa de historial.
- **Comando de ejecución**:
  ```bash
  flutter test test/data/datasources/chat_local_datasource_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] Las conversaciones de chat persisten tras reiniciar la app.
- [ ] La UI permite consultar y limpiar el historial de mensajes.
- [ ] El datasource remoto no conserva estado volátil compartido.
