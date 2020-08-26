import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static setString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<T> get<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T;
  }

  static void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static void clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static void initTest() {
    SharedPreferences.setMockInitialValues({});
  }
}
