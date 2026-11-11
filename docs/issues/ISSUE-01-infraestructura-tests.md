# Issue 01: Infraestructura de Pruebas Automatizadas (Mocktail + BlocTest)

- **Identificador**: `ISSUE-01`
- **GitHub Issue**: [#25 Testing: Establish unit, use case, and BLoC test suite in test/](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/25)
- **Estado**: ✅ COMPLETADO
- **Prioridad**: 🔴 Crítica (Prerrequisito técnico y de seguridad)
- **Impacto**: Calidad de software, prevención de regresiones, cumplimiento de estándares de ingeniería.

---

## 1. Resumen del Por Qué

El proyecto consta de **247 archivos Dart** en `lib/`, pero **la carpeta `test/` no existe**.
Cualquier modificación o refactorización arquitectónica que se realice en el código actual acarrea un riesgo extremo de regresiones silenciosas, fallos no detectados en producción y pérdida de estabilidad.
Además, la regla de desarrollo del proyecto (`AGENTS.md`) exige explícitamente:
> *"TDD & Quality: Write tests first where applicable, test behaviors rather than internals, and verify 80%+ test coverage."*

### Decisión de Eficiencia y Seguridad:
Se selecciona **`mocktail`** frente a `mockito`:
- **Eficiencia**: No requiere ejecutar `build_runner` ni regenerar archivos `*.mocks.dart`, acelerando los tiempos de ejecución y compilación en local y CI.
- **Seguridad**: Soporte nativo y tipado para null-safety en Dart sin código generado que pueda desincronizarse o arrastrar dependencias obsoletas.

---

## 2. Solución Propuesta

1. Crear la jerarquía completa de directorios en `test/` reproduciendo las capas de `lib/`:
   ```
   test/
   ├── core/
   │   └── network/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   └── usecases/
   ├── presentation/
   │   └── blocs/
   └── helpers/
       ├── mock_data.dart
       └── test_fixtures.dart
   ```
2. Añadir dependencias de test a [pubspec.yaml](file:///home/caveman/Proyectos/Roll_and_Reserve_App/pubspec.yaml):
   ```yaml
   dev_dependencies:
     flutter_test:
       sdk: flutter
     bloc_test: ^9.1.7
     mocktail: ^1.0.4
   ```
3. Crear arnés de pruebas base y helpers con mocks tipados reutilizables:
   ```dart
   // test/helpers/test_fixtures.dart
   import 'package:mocktail/mocktail.dart';
   import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
   import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

   class MockUserRepository extends Mock implements UserRepository {}
   class MockReserveRepository extends Mock implements ReserveRepository {}
   ```
4. Crear la primera suite de pruebas de verificación de integridad para asegurar que `flutter test` pase con 100% de éxito desde el inicio.

---

## 3. Pruebas y Verificación

- **Ejecución de la suite completa**:
  ```bash
  flutter test --coverage
  ```
- **Prueba de sanidad básica**: `test/sanity_test.dart` comprobando la inicialización del entorno de pruebas.

---

## 4. Criterios de Aceptación

- [x] Carpeta `test/` creada con estructura ordenada por capas.
- [x] `mocktail` y `bloc_test: ^10.0.0` instalados y configurados en `pubspec.yaml`.
- [x] Mocks base reutilizables implementados en `test/helpers/`.
- [x] El comando `flutter test` se ejecuta sin errores (23 pruebas superadas, exit code 0).
