import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  static const _token = 'token';
  static const _name = 'admin_name';
  static const _email = 'admin_email';

  static Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, value);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  static Future<void> saveAdminName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, value);
  }

  static Future<String?> getAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  static Future<void> saveAdminEmail(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, value);
  }

  static Future<String?> getAdminEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_token);
    await prefs.remove(_name);
    await prefs.remove(_email);
  }
}
