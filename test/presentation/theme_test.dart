import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';

void main() {
  group('AppTheme Configuration', () {
    test('lightTheme has Material 3 enabled and proper color scheme', () {
      final theme = AppTheme.lightTheme;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, equals(AppTheme.primaryColor));
      expect(theme.colorScheme.secondary, equals(AppTheme.secondaryColor));
      expect(theme.scaffoldBackgroundColor, equals(AppTheme.backgroundColor));
    });

    test('lightTheme textTheme contains defined typography styles', () {
      final theme = AppTheme.lightTheme;

      expect(
        theme.textTheme.headlineLarge?.fontSize,
        equals(AppTheme.titleStyle.fontSize),
      );
      expect(
        theme.textTheme.headlineLarge?.fontWeight,
        equals(AppTheme.titleStyle.fontWeight),
      );
      expect(
        theme.textTheme.headlineLarge?.color,
        equals(AppTheme.titleStyle.color),
      );
      expect(
        theme.textTheme.titleMedium?.fontSize,
        equals(AppTheme.subtitleStyle.fontSize),
      );
      expect(
        theme.textTheme.labelLarge?.fontSize,
        equals(AppTheme.buttonStyle.fontSize),
      );
    });

    test('lightTheme button themes are configured', () {
      final theme = AppTheme.lightTheme;

      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.textButtonTheme.style, isNotNull);
    });

    testWidgets('Theme.of(context) resolves corporate colors in MaterialApp',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const Scaffold(
                body: Center(
                  child: Text('Theme Verification'),
                ),
              );
            },
          ),
        ),
      );

      final theme = Theme.of(capturedContext);
      expect(theme.colorScheme.primary, equals(AppTheme.primaryColor));
      expect(theme.colorScheme.secondary, equals(AppTheme.secondaryColor));
      expect(theme.useMaterial3, isTrue);
    });
  });
}
