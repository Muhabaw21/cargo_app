import 'package:shared_preferences/shared_preferences.dart';

class LogoStorageHelper {
  static const String _tokenKey = 'jwt';
  Future setLogo(String logo) async {
    final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString(_tokenKey, logo);
  }

  Future getLogo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_tokenKey);
  }
}
