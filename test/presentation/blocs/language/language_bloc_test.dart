import 'dart:ui';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_event.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  group('LanguageBloc', () {
    test('initial state has Spanish (es) locale', () {
      final bloc = LanguageBloc(mockSharedPreferences);
      expect(bloc.state.locale, const Locale('es'));
    });

    blocTest<LanguageBloc, LanguageState>(
      'emits correct Locale when ChangeLanguageEvent is added',
      build: () {
        when(() => mockSharedPreferences.setString('locale', 'en'))
            .thenAnswer((_) async => true);
        return LanguageBloc(mockSharedPreferences);
      },
      act: (bloc) => bloc.add(ChangeLanguageEvent(const Locale('en'))),
      expect: () => [
        const LanguageState(Locale('en')),
      ],
      verify: (_) {
        verify(() => mockSharedPreferences.setString('locale', 'en')).called(1);
      },
    );

    blocTest<LanguageBloc, LanguageState>(
      'emits saved Locale when GetLocaleEvent is added and preference exists',
      build: () {
        when(() => mockSharedPreferences.getString('locale')).thenReturn('fr');
        return LanguageBloc(mockSharedPreferences);
      },
      act: (bloc) => bloc.add(GetLocaleEvent()),
      expect: () => [
        const LanguageState(Locale('fr')),
      ],
    );

    blocTest<LanguageBloc, LanguageState>(
      'emits default Spanish Locale when GetLocaleEvent is added but no preference exists',
      build: () {
        when(() => mockSharedPreferences.getString('locale')).thenReturn(null);
        return LanguageBloc(mockSharedPreferences);
      },
      act: (bloc) => bloc.add(GetLocaleEvent()),
      expect: () => [
        const LanguageState(Locale('es')),
      ],
    );
  });
}
