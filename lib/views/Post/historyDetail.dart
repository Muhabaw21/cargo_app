import 'dart:convert';
import 'package:cargo/shared/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../model/cargo.dart';
import '../../shared/checkConnection.dart';
import '../../shared/storage_hepler.dart';
import 'histrory.dart';

class cargoHistoryDetail extends StatefulWidget {
  final int? cargoId;
  cargoHistoryDetail({super.key, required this.cargoId});

  @override
  State<cargoHistoryDetail> createState() => _cargoHistoryDetailState();
}

class _cargoHistoryDetailState extends State<cargoHistoryDetail> {
  Future? futureCargo;
  fetchCargoDetail() async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    final response = await http.get(
        Uri.parse(
            'http://164.90.174.113:9090/Api/Cargo/All/Cargos/${widget.cargoId}'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        });

    if (response.statusCode == 200) {
      Map cargoJson = json.decode(response.body);
      return Cargo.fromJson(cargoJson);
    } else {
      Fluttertoast.showToast(
        msg: 'Failed load data with status code ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  bool? _isConnected;

  @override
  void initState() {
    super.initState();
    checkInternetConnection().then((value) {
      setState(() {
        _isConnected = value;
      });
    });
    futureCargo = fetchCargoDetail();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.white,
        title: Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: screenWidth * 0.12),
            height: 40,
            child: const Center(
              child: Text(
                "History Detail",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )),
      ),
      body: Center(
        child: FutureBuilder(
          future: futureCargo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Cargo cargo = snapshot.data!;
              return Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Cargo ID"),
                        trailing: Text('${cargo.id}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("From"),
                        trailing: Text('${cargo.pickUp}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("To"),
                        trailing: Text('${cargo.dropOff}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Date"),
                        trailing: Text('${cargo.date}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Cargo Type"),
                        trailing: Text('${cargo.cargoType}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Cargo Owner"),
                        trailing: Text('${cargo.cargoOwner}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Packaging"),
                        trailing: Text('${cargo.packaging}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Weight"),
                        trailing: Text('${cargo.weight}'),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text("Cargo Status"),
                        trailing: Text('${cargo.status}'),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return Center(child: LoadingSpinner());
          },
        ),
      ),
    );
  }
}
