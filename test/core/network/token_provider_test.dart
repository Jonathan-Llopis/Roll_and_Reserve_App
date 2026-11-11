import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/network/token_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TokenProviderImpl tokenProvider;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    tokenProvider = TokenProviderImpl(sharedPreferences: mockSharedPreferences);
  });

  group('TokenProvider', () {
    test('getToken returns token when it exists and is not empty', () async {
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('valid_jwt_token');

      final result = await tokenProvider.getToken();

      expect(result, 'valid_jwt_token');
      verify(() => mockSharedPreferences.getString('token')).called(1);
    });

    test('getToken returns null when token is null or blank', () async {
      when(() => mockSharedPreferences.getString('token')).thenReturn(null);

      final result = await tokenProvider.getToken();

      expect(result, isNull);
    });

    test('hasValidToken returns true when token is present', () async {
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('valid_token');

      final result = await tokenProvider.hasValidToken();

      expect(result, isTrue);
    });

    test('clearToken removes token from SharedPreferences', () async {
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      await tokenProvider.clearToken();

      verify(() => mockSharedPreferences.remove('token')).called(1);
    });

    test('saveToken saves token in SharedPreferences', () async {
      when(() => mockSharedPreferences.setString('token', 'new_token'))
          .thenAnswer((_) async => true);

      await tokenProvider.saveToken('new_token');

      verify(() => mockSharedPreferences.setString('token', 'new_token'))
          .called(1);
    });
  });
}
