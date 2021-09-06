import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  const Auth._();

  static void saveData({
    String name = 'khaled',
    String passowrd = 'khaled',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('userData', [name, passowrd]);
  }

  static Future<List<String>> fetchData() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> userData = prefs.getStringList('userData')!;
    return userData;
  }
}
