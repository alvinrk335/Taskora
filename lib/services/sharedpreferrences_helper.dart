import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Menyimpan profilePic
  static Future<void> saveProfilePic(String profilePic) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePic', profilePic);
  }

  // Mengambil profilePic yang disimpan
  static Future<String?> getProfilePic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profilePic');
  }

  // Menyimpan status login user (bisa dengan ID atau token)
  static Future<void> saveUserLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Mengambil status login user
  static Future<bool?> getUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');
  }
}
