import 'package:cargo/shared/customAppbar.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:flutter/material.dart';

import '../../model/alert.dart';
import 'Alert_Detail.dart';

class Alert_Type extends StatefulWidget {
  const Alert_Type({super.key});

  @override
  State<Alert_Type> createState() => _Alert_TypeState();
}

class _Alert_TypeState extends State<Alert_Type> {
  final List<Alert> bill = [
    Alert(
        driverName: "Alex",
        plateNumber: "08231",
        alertLocation: "Dire Dawa",
        alertType: "Off Road"),
    Alert(
        driverName: "Alex",
        plateNumber: "08231",
        alertLocation: "Dire Dawa",
        alertType: "Off Road"),
    Alert(
        driverName: "Alex",
        plateNumber: "08231",
        alertLocation: "Dire Dawa",
        alertType: "Off Road"),
  ];
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
                context, MaterialPageRoute(builder: (context) => BottomNav()));
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
          color: Colors.white,
          child: const Center(
            child: Text("Alert Page"),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  ' DName',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Plate Number',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Location',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Alert Type',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: screenWidth,
            height: 5,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 10, left: 18, right: 18),
          ),
          Column(
              children: bill.map((alert) {
            return Container(
              height: screenHeight * 0.2,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.green.shade900, width: 6))),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Alert_Detail()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(alert.driverName),
                        Text(alert.plateNumber),
                        Text(alert.alertLocation),
                        Text(alert.alertType),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList())
        ]),
      ),
    );
  }
}
