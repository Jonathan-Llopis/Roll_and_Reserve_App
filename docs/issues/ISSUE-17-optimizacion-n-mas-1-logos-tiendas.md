# Issue 17: Eliminación de Descarga Secuencial N+1 de Logos en `getAllShops()`

- **Identificador**: `ISSUE-17`
- **GitHub Issue**: [#20 Performance: Eliminate N+1 sequential logo downloads in getAllShops()](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/20)
- **Prioridad**: 🟡 Media / Rendimiento (Eficiencia de Red y Batería)
- **Impacto**: Eliminación de bloqueos de red y reducción drástica de latencia al cargar la lista de tiendas.

---

## 1. Resumen del Por Qué

En `ShopRepositoryImpl.getAllShops()`, tras obtener la lista de tiendas remotas mediante `remoteDataSource.getAllShops(token)`, se ejecuta un `Future.wait` que invoca `remoteDataSource.getShopLogo` para cada tienda de la lista, descargando el binario completo de la imagen en un archivo local temporal antes de retornar la lista al dominio:

```dart
final shopsModels = await remoteDataSource.getAllShops(token);
final shopsWithLogo = await Future.wait(
  shopsModels.map((model) async {
    final logo = await remoteDataSource.getShopLogo(model.logoId, token);
    return model.toShopEntity(logo);
  }),
);
```

Para una lista de 20 tiendas, esto provoca 21 peticiones de red simultáneas y bloqueantes, saturando la conexión móvil, aumentando drásticamente la latencia de pantalla (pantalla de carga prolongada), y consumiendo batería y ancho de banda innecesariamente.

---

## 2. Solución Propuesta

1. **Exponer URL o Identificador de Logo en `ShopEntity`**:
   Permitir que la entidad contenga la URL pública o endpoint del logo en lugar del archivo binario descargado de antemano.
2. **Carga Bajo Demanda con Caché**:
   Utilizar `CachedNetworkImage` en la capa de presentación (`lib/presentation/widgets/`) para solicitar la imagen solo cuando la tarjeta de la tienda se renderice en pantalla.
3. **Eliminar Descarga Bloqueante**:
   Retornar inmediatamente las entidades de tienda desde `getAllShops` sin esperar a descargar los binarios de las imágenes.

---

## 3. Pruebas y Verificación

- **Pruebas Unitarias de Repositorio**:
  Verificar con `mocktail` que `ShopRepositoryImpl.getAllShops()` hace una única llamada de red y retorna las tiendas sin llamar a `getShopLogo` en bucle.
- **Pruebas de Widgets**:
  Verificar que `ShopCard` muestra un placeholder mientras carga el logo con `CachedNetworkImage`.

---

## 4. Criterios de Aceptación

- [ ] `ShopEntity` expone la URL/endpoint del logo.
- [ ] La capa de presentación utiliza `CachedNetworkImage` para carga perezosa y cacheo en disco.
- [ ] `getAllShops()` elimina el `Future.wait` bloqueante de descarga binaria de logos.
- [ ] La pantalla de tiendas carga de forma instantánea sin retrasos perceptibles.
