import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  static String getString(String key, {String defValue = ''}) {
    if (!prefs.containsKey(key)) return defValue;
    return prefs.getString(key) ?? defValue;
  }

  static int getInt(String key, {int defValue = 0}) {
    if (!prefs.containsKey(key)) return defValue;
    return prefs.getInt(key) ?? defValue;
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (!prefs.containsKey(key)) return defValue;
    return prefs.getBool(key) ?? defValue;
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    if (!prefs.containsKey(key)) return defValue;
    return prefs.getDouble(key) ?? defValue;
  }

  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (!prefs.containsKey(key)) return defValue;
    return prefs.getStringList(key) ?? defValue;
  }

  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await prefs.clear();
  }

  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  static Set<String> getKeys() {
    return prefs.getKeys();
  }
}
