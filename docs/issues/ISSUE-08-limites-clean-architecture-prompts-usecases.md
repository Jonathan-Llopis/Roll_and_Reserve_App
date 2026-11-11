# Issue 08: Reestructuración de Límites de Clean Architecture (Prompts a Data y UseCases Especializados)

- **Identificador**: 
- **GitHub Issue**: [#39](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/39)`ISSUE-08`
- **Prioridad**: 🟡 Media (Modularidad y Separación de Capas)
- **Impacto**: Coherencia en Clean Architecture y orden de casos de uso por dominio de negocio.

---

## 1. Resumen del Por Qué

1. **Lógica de Features en `lib/core/`**:
   - [lib/core/prompt.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/core/prompt.dart)
   - [lib/core/prompt_asistente.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/core/prompt_asistente.dart)
   - [lib/core/rol_prompt/prompt.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/core/rol_prompt/prompt.dart)
   Los prompts de IA son lógica y especificación detallada de asistentes concretos, no utilidades transversales. Pertenecen a la capa de infraestructura de datos o servicios de IA.
2. **Servicio de Notificaciones en UI**:
   - [lib/presentation/functions/notification_service.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/functions/notification_service.dart) es un servicio de infraestructura de Firebase Cloud Messaging, pero está metido dentro de `presentation/functions/`.
3. **Casos de Uso de Juegos y Eventos Mezclados con Reservas**:
   - `lib/domain/usecases/reserve_usecases/` contiene casos de uso de juegos (`search_games_usecase.dart`, `get_all_games_usecase.dart`, `get_all_categories_usecase.dart`, `get_all_dificulties_usecase.dart`) y de eventos de tiendas (`create_event_usecase.dart`, `get_events_shop_usecase.dart`).

---

## 2. Solución Propuesta

1. Reubicar los prompts de IA en `lib/data/datasources/ai/prompts/`.
2. Mover `notification_service.dart` a `lib/core/services/notification_service.dart` e inyectarlo formalmente mediante `GetIt` (`sl`).
3. Crear directorios de casos de uso acordes a su modelo de dominio:
   - `lib/domain/usecases/game_usecases/`
   - `lib/domain/usecases/event_usecases/`
4. Desmantelar la carpeta `lib/presentation/functions/`, reubicando las constantes en `lib/core/constants/` y los validadores en `lib/core/utils/`.

---

## 3. Pruebas y Verificación

- **Compilación y Análisis**:
  ```bash
  flutter analyze
  ```
  Comprobar que todas las referencias e importaciones se hayan actualizado limpiamente.

---

## 4. Criterios de Aceptación

- [ ] `lib/core/` contiene únicamente código transversal a toda la aplicación.
- [ ] Los casos de uso de juegos y eventos se encuentran agrupados en sus propios dominios.
- [ ] La carpeta `lib/presentation/functions/` queda eliminada.
