import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /*-------------- Save string data ---------------*/
  static Future<bool> saveStringData({
    required String key,
    required String value,
  }) async {
    await _sharedPreferences.setString(key, value);
    print('String data: $value -> saved successfully');
    return true;
  }

  /*------------ Get String data from shared prefs --------------*/
  static String? getStringData({required String key}) {
    String? value = _sharedPreferences.getString(key);
    return value;
  }

  static Future<bool> clearStringData({required String key}) async {
    await _sharedPreferences.remove(key);
    return true;
  }

  static Future<bool> clearAllData() async {
    await _sharedPreferences.clear();
    print('All data cleared successfully');
    return true;
  }
}
