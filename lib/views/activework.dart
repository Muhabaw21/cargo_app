import 'dart:convert';
import 'dart:io';

import 'package:cargo/shared/constant.dart';
import 'package:cargo/shared/storage_hepler.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/VehicleListForCargo.dart';
class ExpandableListView extends StatefulWidget {
  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State {
  bool isPressed = true;
  TextEditingController searchController = TextEditingController();
  List _data = generateItems(5);
  List<Cargo_Vehicle> _Cargos = [];
  Future<List<Cargo_Vehicle>> _fetchCargoDrivers() async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    print("Access Token: $accessToken");
    try {
      final response = await http.get(
          Uri.parse("http://164.90.174.113:9090/Api/Cargo/All/CargoDrivers/67"),
          headers: {
            "Authorization": "Bearer $accessToken",
          });
      print('Statuscode: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Ignore the status code and only check if the response body contains the expected data

      if (response.body.isNotEmpty &&
          response.body.contains('cargoDriversINFs')) {
        final jsonData = jsonDecode(response.body);
        List<Cargo_Vehicle> cargoDrivers = []; // <-- Explicitly Declare as List
        if (jsonData['cargoDriversINFs'] != null) {
          for (var item in jsonData['cargoDriversINFs']) {
            cargoDrivers.add(Cargo_Vehicle.fromJson(item));
          }
        }
        return cargoDrivers;
      } else {
        throw Exception('Failed to fetch data: Response body is empty');
      }
    } catch (e) {
      print('Error in _fetchCargoDrivers(): $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future? futureCargoDrivers;

  @override
  void initState() {
    super.initState();
    futureCargoDrivers = _fetchCargoDrivers().then((value) {
      setState(() {
       // cargo = value;
      });
    }).catchError((error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch data'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder(
        future: futureCargoDrivers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  // Add more properties of CargoDriver as needed
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Item {
  Item({required this.title, this.isExpanded = false});

  String title;
  bool isExpanded;
}

List generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(title: 'Item $index');
  });
}
