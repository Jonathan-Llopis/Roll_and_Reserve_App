# Issue 15: Integración del Sistema de Temas `AppTheme` y Escalado Responsivo `ScreenUtil`

- **Identificador**: 
- **GitHub Issue**: [#43](https://github.com/Jonathan-Llopis/Roll_and_Reserve_App/issues/43)`ISSUE-15`
- **Prioridad**: 🟢 Normal (Consistencia de UI y Experiencia de Usuario)
- **Impacto**: Estandarización visual, adaptación multi-pantalla y preparación para tema oscuro.

---

## 1. Resumen del Por Qué

El archivo [lib/config/theme/theme.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/config/theme/theme.dart) contiene una definición de estilos corporativos, degradados y botones.
Sin embargo, [lib/main.dart](file:///home/caveman/Proyectos/Roll_and_Reserve_App/lib/main.dart#L129) no lo utiliza y arranca con un tema genérico:
```dart
theme: ThemeData(primarySwatch: Colors.blue),
```
Como consecuencia, decenas de componentes y pantallas recurren a decoraciones fijas en línea, colores duplicados (`Color(0xFF6A11CB)`) y tamaños de fuente fijos sin usar `ScreenUtil` (`.sp`, `.w`, `.h`), provocando inconsistencias visuales en dispositivos pequeños o grandes.

---

## 2. Solución Propuesta

1. Completar la factoría `AppTheme.lightTheme` en `lib/config/theme/theme.dart`:
   ```dart
   static ThemeData get lightTheme {
     return ThemeData(
       useMaterial3: true,
       colorScheme: ColorScheme.fromSeed(
         seedColor: primaryColor,
         primary: primaryColor,
         secondary: secondaryColor,
       ),
       elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonAcceptStyle),
       textButtonTheme: TextButtonThemeData(style: textButtonAcceptStyle),
       textTheme: const TextTheme(
         headlineLarge: titleStyle,
         bodyMedium: TextStyle(color: textColor),
       ),
     );
   }
   ```
2. Asignar `theme: AppTheme.lightTheme` en `main.dart`.
3. Sustituir estilos hardcodeados en botones, diálogos y formularios para que consuman `Theme.of(context)`.

---

## 3. Pruebas y Verificación

- **Pruebas de Renderizado de Widgets**: `test/presentation/theme_test.dart`:
  - Verificar que `MaterialApp` aplique los colores y estilos corporativos definidos en `AppTheme`.
- **Comando de ejecución**:
  ```bash
  flutter test test/presentation/theme_test.dart
  ```

---

## 4. Criterios de Aceptación

- [ ] `main.dart` aplica el tema corporativo unificado.
- [ ] Los botones y títulos principales consumen estilos centralizados.
- [ ] La UI se adapta correctamente a diferentes resoluciones mediante `ScreenUtil`.
