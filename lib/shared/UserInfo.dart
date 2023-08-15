import 'package:shared_preferences/shared_preferences.dart';

class UserHelper{
   static const String _responseKey = 'response_json';

  Future saveResponse(String responseJson) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_responseKey, responseJson);
  }

  Future getResponse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_responseKey);
  }
}