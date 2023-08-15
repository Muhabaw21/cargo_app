// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// import '../model/Login.dart';
// import '../model/logoAvator.dart';
// import 'APIService.dart';

// class APIService {
//   static String? cargoOwner;
//   var client = http.Client();
//   static Future<bool> loginCargo(
//     LoginRequestModel model,
//   ) async {
//     const storage = FlutterSecureStorage();
//     var client = http.Client();
//     var token = await storage.read(key: 'jwt');
//     Map<String, String> requestHeaders = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//     var url = Uri.http(ApIConfig.urlAPI, ApIConfig.logIn);
//     var response = await client.post(url,
//         headers: requestHeaders, body: jsonEncode(model.toJson()));
//     print(response.body);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       print(data);
//       await storage.write(key: "jwt", value: data["jwt"]);

//       cargoOwner = data["user"]["role"][0];

//       print(cargoOwner);

//       return true;
//     } else {
//       return false;
//     }
//   }

//   static Future fetchLogoAndAvatar() async {
//     const storage = FlutterSecureStorage();
//     String url = 'http://64.226.104.50:9090/Api/Admin/LogoandAvatar';
//     var token = await storage.read(key: 'jwt');
//     final response = await http.get(Uri.parse(url), headers: {
//       "Content-Type": "application/json",
//       'Accept': 'application/json',
//       "Authorization": "Bearer $token",
//     });
//     print(jsonDecode(response.body));
//     if (response.statusCode == 200) {
//       // If the server returns a 200 status code (OK), parse the data
//       Map json = jsonDecode(response.body);
//       return LogoAndAvatar.fromJson(json);
//     } else {
//       // If the server returns an error status code, throw an exception
//       throw Exception('Failed to load logo and avatar');
//     }
//   }
// }
