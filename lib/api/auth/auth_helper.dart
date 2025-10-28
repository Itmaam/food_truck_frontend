import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static late final FlutterSecureStorage secureStorage;
  static late final SharedPreferences sharedPreferences;
  static late final Map<String, String> deviceHeaders;

  static Future<void> init() async {
    secureStorage = const FlutterSecureStorage();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<String?> getBearerToken() {
    return secureStorage.read(key: 'bearerToken');
  }

  static Future<void> removeSession() async {
    await secureStorage.delete(key: 'bearerToken');
    await sharedPreferences.remove('user');
  }
}
