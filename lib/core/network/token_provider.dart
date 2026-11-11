import 'package:roll_and_reserve/core/security/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenProvider {
  Future<String?> getToken();
  Future<bool> hasValidToken();
  Future<void> clearToken();
  Future<void> saveToken(String token);
}

class TokenProviderImpl implements TokenProvider {
  final SecureStorageService secureStorageService;

  TokenProviderImpl({
    SecureStorageService? secureStorageService,
    SharedPreferences? sharedPreferences,
  }) : secureStorageService = secureStorageService ??
            SecureStorageServiceImpl(sharedPreferences: sharedPreferences);

  @override
  Future<String?> getToken() async {
    final token = await secureStorageService.read('token');
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    return token;
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<void> clearToken() async {
    await secureStorageService.delete('token');
  }

  @override
  Future<void> saveToken(String token) async {
    await secureStorageService.write('token', token);
  }
}
