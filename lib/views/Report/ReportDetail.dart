import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/bill_details.dart';
import '../../shared/customAppbar.dart';
import '../../shared/storage_hepler.dart';
import '../Bill/BillCargo.dart';
import '../Bottom_Navigation.dart';
import 'package:http/http.dart' as http;

class Bill_Detail extends StatefulWidget {
  final int? cargoId;
  const Bill_Detail({super.key, required this.cargoId});

  @override
  State<Bill_Detail> createState() => _Bill_DetailState();
}

class _Bill_DetailState extends State<Bill_Detail> {
  List<BillDetail> billDetails = [];

  @override
  void initState() {
    super.initState();
    fetchBillDetails();
  }

  fetchBillDetails() async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    final response = await http.get(
        Uri.parse(
            'http://164.90.174.113:9090/Api/Payment/CargOwner/Status/${widget.cargoId}'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        });

    if (response.statusCode == 200) {
      var billJson = json.decode(response.body);
      return BillDetail.fromJson(billJson);
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CargoBill()));
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
              "Bill History Detail",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: billDetails.map((detail) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 15),
                  child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5))),
                            child: ListTile(
                              title: const Text(
                                "Bill Status",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                detail.payment,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text("Departure"),
                            trailing: Text(detail.pickUp),
                          ),
                          ListTile(
                            title: const Text("Destination"),
                            trailing: Text(detail.dropOff),
                          ),
                          ListTile(
                            title: const Text("Cargo"),
                            trailing: Text(detail.cargo.toString()),
                          ),
                          ListTile(
                            title: const Text("Payment Due Date"),
                            trailing: Text(detail.paymentDeadline),
                          ),
                          ListTile(
                            title: const Text("Cargo Type"),
                            trailing: Text(
                              detail.cargoType,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              );
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 50),
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                print("Share button pressed");
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "10",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20),
            child: const Text(
              "Day's left",
              style: TextStyle(
                fontSize: 25,
                color: Colors.amber,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
