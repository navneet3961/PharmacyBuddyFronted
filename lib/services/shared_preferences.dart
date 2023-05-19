import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static Future createCache(String token, String cartId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("x-access-token", token);
    preferences.setString("cartId", cartId);
  }

  static Future getCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("x-access-token");
  }

  static Future getCartId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("cartId");
  }

  static Future destroyCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("x-access-token", "");
    preferences.remove("cartId");
  }
}
