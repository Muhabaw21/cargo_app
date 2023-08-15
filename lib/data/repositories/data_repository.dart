import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../model/cargo.dart';
import '../../shared/storage_hepler.dart';

class DataRepository {
  static const String baseUrl = 'http://64.226.104.50:9090/Api/Cargo/PostCargo';
  Future<List<Cargo>> postCargo(Cargo cargo) async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();

    final url = Uri.parse('your_api_endpoint_here');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.post(url, headers: headers, body: jsonDecode('cargo'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<Cargo> cargos =
          List<Cargo>.from(jsonData.map((data) => Cargo.fromJson(data)));
      return cargos;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
