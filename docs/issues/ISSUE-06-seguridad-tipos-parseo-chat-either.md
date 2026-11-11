# Issue 06: Conversión Numérica Segura en Modelos y Retorno Funcional `Either` en Chat

- **Identificador**: `ISSUE-06`
- **GitHub Issue**: Relacionado con [#24 Format: Replace brittle substring date slicing with intl DateFormat](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/24)
- **Prioridad**: 🟡 Media (Seguridad de Tipos y Coherencia de Arquitectura)
- **Impacto**: Prevención de fallos en parseo de datos remotos y homogeneización del flujo de errores.

---

## 1. Resumen del Por Qué

1. **Conversión Numérica No Segura**:
   En [lib/data/models/functions_for_models.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/data/models/functions_for_models.dart#L12):
   ```dart
   sumaRatings += review['raiting'] as int;
   ```
   Si el backend devuelve una puntuación decimal (por ejemplo, `4.5`), Dart lanza inmediatamente un error en tiempo de ejecución: `TypeError: 4.5 is not a subtype of type int`.
2. **Ruptura de Convención en Chat**:
   En [lib/data/repositories/chat_repository_impl.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/data/repositories/chat_repository_impl.dart#L19-L35), todos los métodos lanzan excepciones directas con `throw Exception('Error starting chat: $e')`. Esto rompe la regla de Clean Architecture adoptada en todos los demás repositorios (`reserve`, `shop`, `table`), los cuales retornan `Future<Either<Failure, T>>`, forzando a los BLoCs de chat a utilizar bloques `try/catch` no estandarizados.

---

## 2. Solución Propuesta

1. Modificar las funciones de cálculo para aceptar cualquier tipo numérico de forma segura:
   ```dart
   double calcularMediaRatings(List<dynamic> reviews) {
     if (reviews.isEmpty) return 0.0;
     double sumaRatings = 0.0;
     int contador = 0;

     for (final review in reviews) {
       if (review is Map) {
         final rawRating = review['raiting'] ?? review['rating'];
         if (rawRating is num) {
           sumaRatings += rawRating.toDouble();
           contador++;
         }
       }
     }
     return contador > 0 ? (sumaRatings / contador) : 0.0;
   }
   ```
2. Refactorizar la interfaz `ChatRepository` y su implementación `ChatRepositoryImpl` para que todos sus métodos retornen `Future<Either<Failure, String>>`.

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias de Modelos**: `test/data/models/functions_for_models_test.dart`:
  - Cálculo con enteros: `[{'raiting': 4}, {'raiting': 5}]` $\rightarrow$ `4.5`.
  - Cálculo con números con punto flotante: `[{'raiting': 3.5}, {'raiting': 4.5}]` $\rightarrow$ `4.0`.
  - Manejo de listas vacías o valores nulos sin arrojar `TypeError`.
- **Comando de ejecución**:
  ```bash
  flutter test test/data/models/functions_for_models_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] Todas las lecturas numéricas de JSON emplean `(raw as num?)?.toDouble() ?? 0.0`.
- [ ] `ChatRepository` implementa el retorno funcional `Either<Failure, String>`.
- [ ] 100% de cobertura de pruebas unitarias sobre las funciones matemáticas de modelos.
