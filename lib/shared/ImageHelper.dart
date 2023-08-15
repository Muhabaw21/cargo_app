import 'dart:convert';

import 'package:cargo/shared/storage_hepler.dart';
import 'package:http/http.dart' as http;

class ImageHelper {
  Future<String> fetchImage() async {
    try {
      var client = http.Client();
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await http.get(
          Uri.parse('http://64.226.104.50:9090/Api/Admin/LogoandAvatar'),
          headers: requestHeaders);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        Map<String, dynamic> data = json.decode(response.body);
        return data["logo"];
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }
}
