import 'package:shared_preferences/shared_preferences.dart';

   class StorageHelper {
     static const String _tokenKey = 'jwt';

     Future setToken(String token) async {
       final sharedPreferences = await SharedPreferences.getInstance();
       await sharedPreferences.setString(_tokenKey, token);
     }

     Future getToken() async {
       final sharedPreferences = await SharedPreferences.getInstance();
       return sharedPreferences.getString(_tokenKey);
     }

     Future deleteToken() async {
       final sharedPreferences = await SharedPreferences.getInstance();
       await sharedPreferences.remove(_tokenKey);
     }
   }
   