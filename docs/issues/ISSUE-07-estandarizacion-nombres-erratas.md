# Issue 07: Estandarización de Nomenclatura y Corrección de Erratas

- **Identificador**: 
- **GitHub Issue**: [#45](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/45)`ISSUE-07`
- **Prioridad**: 🟡 Media (Mantenibilidad y Calidad de Código)
- **Impacto**: Claridad en el código fuente, consistencia en importaciones y eliminación de deuda técnica.

---

## 1. Resumen del Por Qué

El código presenta múltiples erratas tipográficas en nombres de archivos, clases, interfaces, métodos y propiedades que confunden al desarrollador y degradan la calidad del proyecto:
- `lib/data/datasources/shop_datasoruce.dart` (`datasoruce` $\rightarrow$ `datasource`).
- `lib/domain/repositories/table_respository.dart` (`respository` $\rightarrow$ `repository`).
- `lib/domain/repositories/user_repository.dart` define `abstract class UserRespository` (nombre de la interfaz mal escrito).
- `lib/presentation/screens/screen_stadistics.dart` (`stadistics` $\rightarrow$ `statistics`).
- `lib/domain/entities/user_entity.dart` define `averageRaiting` (`raiting` $\rightarrow$ `rating`).
- `lib/data/datasources/chat_datasource.dart` define el método `sendMessageAssitant` (`assitant` $\rightarrow$ `assistant`).
- `lib/domain/usecases/reserve_usecases/confirmate_reserve_usecase.dart` (`confirmate` $\rightarrow$ `confirm`).
- `lib/domain/usecases/reserve_usecases/get_all_dificulties_usecase.dart` (`dificulties` $\rightarrow$ `difficulties`).

---

## 2. Solución Propuesta

1. Renombrar los archivos:
   - `lib/data/datasources/shop_datasoruce.dart` $\rightarrow$ `shop_datasource.dart`
   - `lib/domain/repositories/table_respository.dart` $\rightarrow$ `table_repository.dart`
   - `lib/presentation/screens/screen_stadistics.dart` $\rightarrow$ `screen_statistics.dart`
   - `confirmate_reserve_usecase.dart` $\rightarrow$ `confirm_reserve_usecase.dart`
   - `get_all_dificulties_usecase.dart` $\rightarrow$ `get_all_difficulties_usecase.dart`
2. Corregir identificadores y clases:
   - `UserRespository` $\rightarrow$ `UserRepository`
   - `averageRaiting` $\rightarrow$ `averageRating` (manteniendo compatibilidad en la deserialización si el JSON del backend trae `'raiting'`)
   - `sendMessageAssitant` $\rightarrow$ `sendMessageAssistant`
   - `ConfirmateReserveUsecase` $\rightarrow$ `ConfirmReserveUseCase`
3. Actualizar todas las rutas de importación afectadas en un commit atómico.

---

## 3. Pruebas y Verificación

- **Análisis Estático Completo**:
  ```bash
  flutter analyze
  ```
  Debe culminar con `0 issues found.`

---

## 4. Criterios de Aceptación

- [ ] Todos los archivos siguen el estándar `snake_case` en inglés correcto.
- [ ] Todas las clases siguen el estándar `UpperCamelCase` sin erratas.
- [ ] No persisten nombres con fallos ortográficos en el código fuente.
- [ ] La compilación y análisis estático finalizan sin advertencias.
