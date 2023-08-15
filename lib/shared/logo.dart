
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future fetchLogoAndAvatar() async {
  try {
    final response = await http.get(
      Uri.parse('http://64.226.104.50:9090/Api/Admin/LogoandAvatar'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('avatar', responseData['avatar']);
      await prefs.setString('logo', responseData['logo']);
    } else {
      print('Failed to load data from API');
    }
  } catch (e) {
    print('Error: $e');
  }
}
Future getLogoAndAvatar() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'avatar': prefs.getString('avatar'),
    'logo': prefs.getString('logo'),
  };
}