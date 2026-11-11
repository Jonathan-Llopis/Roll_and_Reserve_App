# Issue 09: Descomposición de God BLoC `ReserveBloc` (1.661 líneas) en 4 BLoCs Especializados

- **Identificador**: `ISSUE-09`
- **GitHub Issue**: [#16 Decompose ReserveBloc God BLoC and fix state loss in ReserveState](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/16)
- **Prioridad**: 🔴 Alta (Eficiencia de Renderizado y Mantenibilidad)
- **Impacto**: Eliminación de cuellos de botella en la gestión de estado, renderizado óptimo y desacoplamiento.

---

## 1. Resumen del Por Qué

- [lib/presentation/blocs/reserve/reserve_bloc.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/blocs/reserve/reserve_bloc.dart#L30-L70):
  `ReserveBloc` tiene **1.661 líneas de código** e inyecta **17 dependencias posicionales**.
  Atiende cuatro responsabilidades de negocio no relacionadas:
  1. Reservas de mesas en locales.
  2. Eventos organizados por las tiendas.
  3. Catálogo de juegos de mesa, dificultades y categorías.
  4. Gestión de participantes y últimos 10 jugadores.
- [lib/presentation/blocs/reserve/reserve_state.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/blocs/reserve/reserve_state.dart#L8-L53):
  El estado agrupa 11 propiedades opcionales. Cada vez que se busca un juego o se actualiza una mesa, se emite una copia completa del estado, obligando a repintar widgets no relacionados en las pantallas de reservas y eventos.

---

## 2. Solución Propuesta

1. Dividir `ReserveBloc` en cuatro BLoCs especializados:
   - `ReservationBloc`:
     - Eventos: `CreateReservationEvent`, `CancelReservationEvent`, `GetReservationsByDateEvent`, `GetUserReservationsEvent`, `ConfirmReservationEvent`.
     - Estado: `ReservationInitial`, `ReservationLoading`, `ReservationLoaded`, `ReservationFailure`.
   - `EventBloc`:
     - Eventos: `GetShopEventsEvent`, `CreateShopEventEvent`.
     - Estado: `EventInitial`, `EventLoading`, `EventLoaded`, `EventFailure`.
   - `GameCatalogBloc`:
     - Eventos: `GetGamesEvent`, `SearchGamesEvent`, `GetCategoriesEvent`, `GetDifficultiesEvent`.
     - Estado: `GameCatalogInitial`, `GameCatalogLoading`, `GameCatalogLoaded`, `GameCatalogFailure`.
   - `PlayerBloc`:
     - Eventos: `AddPlayerToReserveEvent`, `RemovePlayerFromReserveEvent`, `GetLastTenPlayersEvent`.
     - Estado: `PlayerInitial`, `PlayerLoading`, `PlayerLoaded`, `PlayerFailure`.
2. Actualizar las pantallas consumidoras para inyectar y escuchar el BLoC específico que realmente necesitan.

---

## 3. Pruebas y Verificación

- **Pruebas de BLoC con `bloc_test`**:
  - `test/presentation/blocs/reservation/reservation_bloc_test.dart`
  - `test/presentation/blocs/game_catalog/game_catalog_bloc_test.dart`
- **Comando de ejecución**:
  ```bash
  flutter test test/presentation/blocs/
  ```

---

## 4. Criterios de Aceptación

- [ ] `ReserveBloc` queda desmantelado y reemplazado por los 4 BLoCs especializados.
- [ ] Ningún BLoC resultante excede las 350 líneas de código.
- [ ] Los estados solo transportan datos específicos de su ámbito.
- [ ] Reducción comprobada en la cantidad de reconstrucciones innecesarias de widgets.
