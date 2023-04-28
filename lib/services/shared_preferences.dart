import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static Future createCache(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("x-access-token", token);
  }

  static Future getCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("x-access-token");
  }

  static Future destroyCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("x-access-token");
  }
}
