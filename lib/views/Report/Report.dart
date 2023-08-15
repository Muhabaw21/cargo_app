import 'package:cargo/constant/global_variables.dart';
import 'package:cargo/shared/customAppbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../Components/Home_Page.dart';

import '../../Components/Noglow.dart';
import '../../model/report.dart';
import '../Bill/billDetail.dart';
import '../Bottom_Navigation.dart';
import 'ReportDetail.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<ReportModel> report = [
    ReportModel(startTrip: "Jimma", endTrip: "Addis Ababa", Date: "2023-05-20"),
    ReportModel(
        startTrip: "Gondar", endTrip: "Addis Ababa", Date: "2023-05-20"),
    ReportModel(
        startTrip: "Djibouti", endTrip: "Addis Ababa", Date: "2023-05-20"),
    ReportModel(startTrip: "Metema", endTrip: "Gondar", Date: "2023-06-06"),
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 249, 249, 1),
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
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Date',
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                  children: report.map((bill) {
                return Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.7),
                                blurRadius: 8.0,
                                spreadRadius: 2.0,
                                offset: const Offset(
                                  6, // Move to right 7.0 horizontally
                                  8, // Move to bottom 8.0 Vertically
                                ))
                          ],
                        ),
                        height: screenHeight * 0.2,
                        child: ListTile(
                          title: Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        bill.startTrip,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: GlobalVariables.primaryColor,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Icon(Icons.trip_origin,
                                            size: 15,
                                            color: Colors.grey.shade300),
                                      ),
                                      Container(
                                        width: screenWidth * 0.25,
                                        child: const Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            DottedLine(
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.grey,
                                              dashGapRadius: 2.0,
                                            ),
                                            Icon(
                                              Icons.local_shipping,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 8),
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.location_on,
                                            size: 15,
                                            color: Colors.grey.shade300),
                                      ),
                                      Text(
                                        bill.endTrip,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: const DottedLine(
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.grey,
                                    dashGapRadius: 2.0,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    bill.Date,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.amber,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ));
              }).toList())),
        ),
      ),
    );
  }
}
