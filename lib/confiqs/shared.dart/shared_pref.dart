import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Singleton
  static final SharedPreferenceHelper shared =
      SharedPreferenceHelper._privateConstructor();

  SharedPreferenceHelper._privateConstructor();

  //Keys
  final String userId = "userId";

  final String loginStatus = "loginStatus";

  final String userName = "userName";
  final String userType = "userType";

  final String phoneNumber = "phoneNumber";

// methods
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId);
  }

  Future<bool> setUserId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userId, value);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }

  Future<bool> setUserType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userType, value);
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userType);
  }

  Future<bool> setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userName, value);
  }

  Future<bool?> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginStatus) ?? false;
  }

  Future<bool> setLoginStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(loginStatus, value);
  }

  Future<bool> setPhoneNumber(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(phoneNumber, value);
  }

  Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneNumber);
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
