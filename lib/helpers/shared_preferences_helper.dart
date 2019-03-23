import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static setUserId(int userId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt('userId', userId);
  }

  static getUserId() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userId') ?? 0;
  }

  static setCookie(String cookie) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('cookie', cookie);
  }

  static getCookie() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('cookie');
  }
}