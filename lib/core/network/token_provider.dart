import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenProvider {
  Future<String?> getToken();
  Future<bool> hasValidToken();
  Future<void> clearToken();
  Future<void> saveToken(String token);
}

class TokenProviderImpl implements TokenProvider {
  final SharedPreferences sharedPreferences;

  TokenProviderImpl({required this.sharedPreferences});

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString('token');
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
    await sharedPreferences.remove('token');
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('token', token);
  }
}
