# Issue 12: Implementación de `Equatable` e Inmutabilidad en Entidades de Dominio

- **Identificador**: 
- **GitHub Issue**: [#41](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/41)`ISSUE-12`
- **Prioridad**: 🔴 Alta (Eficiencia de Reconstrucción de Widgets y Coherencia de BLoC)
- **Impacto**: Eliminación de repintados innecesarios y soporte para mutaciones inmutables seguras.

---

## 1. Resumen del Por Qué

Ninguna de las entidades de dominio en [lib/domain/entities/](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/domain/entities/) implementa `Equatable` ni sobreescribe `operator ==` o `hashCode`.
Además, [lib/domain/entities/user_entity.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/domain/entities/user_entity.dart#L7) incluye tipos no seguros como `final dynamic avatar;`.

### Impacto en Eficiencia:
En la arquitectura BLoC, la comparación de estados se basa en igualdad por valor. Cuando un estado contiene una lista de entidades sin `Equatable`, Dart realiza una comparación por identidad en memoria (`identical`). Si se emite una nueva lista con los mismos datos tras una operación, BLoC no reconoce que los datos son idénticos y dispara la reconstrucción total de la pantalla.

---

## 2. Solución Propuesta

1. Hacer que todas las entidades de dominio extiendan `Equatable`:
   ```dart
   class UserEntity extends Equatable {
     final String id;
     final String email;
     final int role;
     final String name;
     final String username;
     final dynamic avatar;
     final double averageRating;
     final bool? reserveConfirmation;
     final List<int> notifications;

     const UserEntity({
       required this.id,
       required this.email,
       required this.role,
       required this.name,
       required this.username,
       required this.avatar,
       required this.averageRating,
       this.reserveConfirmation,
       required this.notifications,
     });

     @override
     List<Object?> get props => [
       id, email, role, name, username, averageRating, reserveConfirmation, notifications,
     ];
   }
   ```
2. Añadir el método `copyWith` en cada entidad para facilitar mutaciones inmutables seguras sin tener que reconstruir instancias desde cero.

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias de Entidades**: `test/domain/entities/entity_equality_test.dart`:
  - Verificar que dos instancias de cualquier entidad con idénticos valores evalúen `true` en `entidadA == entidadB`.
  - Probar `copyWith` verificando que genere una nueva instancia preservando la inmutabilidad de la original.
- **Comando de ejecución**:
  ```bash
  flutter test test/domain/entities/
  ```

---

## 4. Criterios de Aceptación

- [ ] Todas las 8 entidades de dominio extienden `Equatable`.
- [ ] Todas las entidades cuentan con método `copyWith`.
- [ ] Los estados de BLoC evitan repintados innecesarios cuando los datos no han cambiado.
