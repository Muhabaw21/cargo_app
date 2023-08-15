import 'package:flutter/material.dart';
import '../../model/alert.dart';
import '../../shared/customAppbar.dart';
import 'Alert.dart';

class Alert_Detail extends StatefulWidget {
  const Alert_Detail({super.key});

  @override
  State<Alert_Detail> createState() => _Alert_DetailState();
}

final List<Alert> alert = [
  Alert(
      driverName: "Alex",
      plateNumber: "08231",
      alertLocation: "Dire Dawa",
      alertType: "Off Road"),
];

class _Alert_DetailState extends State<Alert_Detail> {
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Alert_Type()));
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
            child: Text("Alert Detail"),
          ),
        ),
      ),
      body: Column(
        children: alert.map((detail) {
          return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Card(
                  child: Container(
                    height: screenHeight * 0.4,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom:
                          BorderSide(color: Colors.green.shade500, width: 16),
                    )),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Plate Number"),
                          trailing: Text(detail.plateNumber),
                        ),
                        ListTile(
                          title: Text("Alert Type"),
                          trailing: Text(detail.alertType),
                        ),
                        ListTile(
                          title: Text("Alert Location"),
                          trailing: Text(detail.alertLocation),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        }).toList(),
      ),
    );
  }
}
