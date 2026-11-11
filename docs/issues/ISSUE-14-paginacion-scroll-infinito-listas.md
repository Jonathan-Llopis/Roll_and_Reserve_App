# Issue 14: Paginación y Scroll Infinito en Listados de Tiendas, Reservas y Eventos

- **Identificador**: 
- **GitHub Issue**: [#42](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/42)`ISSUE-14`
- **Prioridad**: 🟡 Media (Eficiencia de Memoria y Consumo de Datos Móviles)
- **Impacto**: Reducción drástica del payload de red, fluidez de scroll a 60/120 fps y escalabilidad.

---

## 1. Resumen del Por Qué

En [lib/presentation/widgets/screen_components/screen_body/body_main_shops.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/presentation/widgets/screen_components/screen_body/body_main_shops.dart#L148-L152) se observa:
```dart
void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    // TODO: Implement lazy loading trigger here
  }
}
```
Actualmente, todas las peticiones a la API descargan la tabla completa de registros sin límite ni paginación (`getAllShops`, `getAllReserves`, `getAllEvents`, `getUsers`). Conforme el número de locales y reservas aumente, esto causará bloqueos en el hilo principal de renderizado, elevado consumo de memoria RAM y alto uso de datos móviles.

---

## 2. Solución Propuesta

1. Modificar los endpoints de consulta en los datasources para aceptar parámetros de paginación (`page`, `limit`):
   ```dart
   Future<List<ShopModel>> getShops({int page = 1, int limit = 20});
   ```
2. Extender los eventos y estados de los BLoCs correspondientes:
   ```dart
   class FetchShopsNextPageEvent extends ShopEvent {}
   ```
   El estado `ShopLoaded` almacenará:
   - `List<ShopEntity> shops`
   - `int currentPage`
   - `bool hasReachedMax`
   - `bool isLoadingMore`
3. Completar el trigger de lazy loading en los listeners de `ScrollController` para solicitar la siguiente página al acercarse al final del scroll.

---

## 3. Pruebas y Verificación

- **Pruebas de BLoC**: `test/presentation/blocs/shops/shop_pagination_test.dart`:
  - Disparar `FetchShopsNextPageEvent` y verificar que la nueva página se concatene a la lista existente sin sobreescribirla.
  - Verificar que `hasReachedMax` cambie a `true` cuando la respuesta contenga una lista vacía.
- **Comando de ejecución**:
  ```bash
  flutter test test/presentation/blocs/shops/
  ```

---

## 4. Criterios de Aceptación

- [ ] Paginación activa en los listados principales de tiendas, eventos y reservas.
- [ ] Indicador visual sutil en la parte inferior durante la carga de nuevas páginas.
- [ ] No existen duplicidades en las listas paginadas.
