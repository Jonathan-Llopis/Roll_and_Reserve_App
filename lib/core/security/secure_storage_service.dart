import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureStorageService {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences? sharedPreferences;

  SecureStorageServiceImpl({
    FlutterSecureStorage? secureStorage,
    this.sharedPreferences,
  }) : secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<String?> read(String key) async {
    try {
      final value = await secureStorage.read(key: key);
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    } catch (_) {}

    // Auto-migrate legacy value from SharedPreferences if present
    final legacyValue = sharedPreferences?.getString(key);
    if (legacyValue != null && legacyValue.trim().isNotEmpty) {
      try {
        await secureStorage.write(key: key, value: legacyValue);
      } catch (_) {}
      await sharedPreferences?.remove(key);
      return legacyValue;
    }

    return null;
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (_) {}
    // Eradicate any plaintext copy in SharedPreferences
    await sharedPreferences?.remove(key);
  }

  @override
  Future<void> delete(String key) async {
    try {
      await secureStorage.delete(key: key);
    } catch (_) {}
    await sharedPreferences?.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    try {
      await secureStorage.deleteAll();
    } catch (_) {}
    await sharedPreferences?.remove('token');
    await sharedPreferences?.remove('email');
    await sharedPreferences?.remove('id');
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      final hasKey = await secureStorage.containsKey(key: key);
      if (hasKey) return true;
    } catch (_) {}
    return sharedPreferences?.containsKey(key) ?? false;
  }
}
