import 'dart:convert';

import 'package:cargo/constant/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/bill_details.dart';
import '../../shared/storage_hepler.dart';
import 'BillCargo.dart';
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
    loadBillDetails();
  }

  Future<void> loadBillDetails() async {
    try {
      List<BillDetail> fetchedBillDetails =
          (await fetchBillDetails()) as List<BillDetail>;
      if (fetchedBillDetails.isNotEmpty) {
        setState(() {
          billDetails = fetchedBillDetails;
        });
        print(billDetails); // Print the value of billDetails
      } else {
        Fluttertoast.showToast(
          msg: 'No bill details found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    } catch (error) {
      print("Error: ${error}");
      Fluttertoast.showToast(
        msg: 'Failed to load data: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<List<BillDetail>> fetchBillDetails() async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    final response = await http.get(
      Uri.parse(
        'http://164.90.174.113:9090/Api/Payment/CargOwner/Status/${widget.cargoId}',
      ),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        "Authorization": "Bearer $accessToken",
      },
    );
    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);
      if (decodedData is List) {
        return decodedData.map((data) => BillDetail.fromMap(data)).toList();
      } else if (decodedData is Map<String, dynamic>) {
        return [BillDetail.fromMap(decodedData)];
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception(
        'Failed to load data with status code ${response.statusCode}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CargoBill()));
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
        children: billDetails.map((detail) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 15),
                  child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: GlobalVariables.primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5))),
                            child: ListTile(
                              title: const Text(
                                "Bill Status",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                detail.payment,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
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
                            trailing: Text(detail.paymentDeadline ?? ''),
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
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 50),
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      print("Share button pressed");
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: GlobalVariables.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          detail.daysForDeadline.toString() ?? "",
                          style: const TextStyle(
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
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                

              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
