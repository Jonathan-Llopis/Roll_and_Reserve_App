import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/network/token_provider.dart';
import 'package:roll_and_reserve/core/security/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late MockSharedPreferences mockSharedPreferences;
  late SecureStorageServiceImpl secureStorageService;
  late TokenProviderImpl tokenProvider;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    mockSharedPreferences = MockSharedPreferences();
    secureStorageService = SecureStorageServiceImpl(
      secureStorage: mockSecureStorage,
      sharedPreferences: mockSharedPreferences,
    );
    tokenProvider = TokenProviderImpl(
      secureStorageService: secureStorageService,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('SecureStorageService', () {
    test('read returns secure value when present in FlutterSecureStorage', () async {
      when(() => mockSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => 'secure_jwt_token');

      final result = await secureStorageService.read('token');

      expect(result, 'secure_jwt_token');
      verify(() => mockSecureStorage.read(key: 'token')).called(1);
      verifyNever(() => mockSharedPreferences.getString(any()));
    });

    test('read auto-migrates plaintext from SharedPreferences when secure storage is empty', () async {
      when(() => mockSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => null);
      when(() => mockSharedPreferences.getString('token'))
          .thenReturn('legacy_plain_token');
      when(() => mockSecureStorage.write(key: 'token', value: 'legacy_plain_token'))
          .thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      final result = await secureStorageService.read('token');

      expect(result, 'legacy_plain_token');
      // Verifies it wrote to secure storage
      verify(() => mockSecureStorage.write(key: 'token', value: 'legacy_plain_token')).called(1);
      // Verifies it wiped plaintext copy from SharedPreferences
      verify(() => mockSharedPreferences.remove('token')).called(1);
    });

    test('write saves value in secure storage and deletes plaintext copy in SharedPreferences', () async {
      when(() => mockSecureStorage.write(key: 'token', value: 'new_secret_token'))
          .thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      await secureStorageService.write('token', 'new_secret_token');

      verify(() => mockSecureStorage.write(key: 'token', value: 'new_secret_token')).called(1);
      verify(() => mockSharedPreferences.remove('token')).called(1);
    });

    test('delete removes key from both secure storage and SharedPreferences', () async {
      when(() => mockSecureStorage.delete(key: 'token'))
          .thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      await secureStorageService.delete('token');

      verify(() => mockSecureStorage.delete(key: 'token')).called(1);
      verify(() => mockSharedPreferences.remove('token')).called(1);
    });

    test('deleteAll removes all sensitive credentials', () async {
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);

      await secureStorageService.deleteAll();

      verify(() => mockSecureStorage.deleteAll()).called(1);
      verify(() => mockSharedPreferences.remove('token')).called(1);
      verify(() => mockSharedPreferences.remove('email')).called(1);
      verify(() => mockSharedPreferences.remove('id')).called(1);
    });
  });

  group('TokenProvider with SecureStorageService', () {
    test('TokenProvider.getToken reads from secure storage', () async {
      when(() => mockSecureStorage.read(key: 'token'))
          .thenAnswer((_) async => 'bearer_123');

      final token = await tokenProvider.getToken();

      expect(token, 'bearer_123');
      expect(await tokenProvider.hasValidToken(), isTrue);
    });

    test('TokenProvider.saveToken writes to secure storage', () async {
      when(() => mockSecureStorage.write(key: 'token', value: 'token_abc'))
          .thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      await tokenProvider.saveToken('token_abc');

      verify(() => mockSecureStorage.write(key: 'token', value: 'token_abc')).called(1);
    });

    test('TokenProvider.clearToken deletes from secure storage', () async {
      when(() => mockSecureStorage.delete(key: 'token'))
          .thenAnswer((_) async {});
      when(() => mockSharedPreferences.remove('token'))
          .thenAnswer((_) async => true);

      await tokenProvider.clearToken();

      verify(() => mockSecureStorage.delete(key: 'token')).called(1);
    });
  });
}
