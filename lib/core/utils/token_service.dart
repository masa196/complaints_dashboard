// lib/core/utils/token_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  TokenService._internal();
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = "auth_token";

  String? _cachedToken;

  /// Load token from secure storage into memory cache.
  Future<String?> loadToken() async {
    _cachedToken = await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  /// Fast getter (may be null if not loaded).
  String? get token => _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }
}
