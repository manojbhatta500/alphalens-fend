import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'auth_token';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  // Delete token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _key);
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _key);
    return token != null && token.isNotEmpty;
  }
}