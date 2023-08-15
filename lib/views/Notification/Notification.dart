import 'package:cargo/shared/constant.dart';
import 'package:cargo/shared/customAppbar.dart';
import 'package:flutter/material.dart';
import '../../model/post.dart';
import '../Bottom_Navigation.dart';
import 'Notification_Detail.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<ListItem> items = [
    ListItem(
        driverName: 'Putin',
        plateNumber: ' 003221',
        Date: "09-05-2023",
        isExpanded: false,
        status: "start"),
    ListItem(
        driverName: 'Victor',
        plateNumber: '03323',
        Date: "08-05-2023",
        isExpanded: false,
        status: "start"),
    ListItem(
        driverName: 'John ',
        plateNumber: '09932',
        Date: "07-05-2023",
        isExpanded: false,
        status: "start"),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
          child: const Center(
            child: Text(
              "Notification",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
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
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: screenWidth,
              height: 5,
              color: Colors.grey,
              margin: const EdgeInsets.only(bottom: 10, left: 18, right: 18),
            ),
            Column(
                children: items.map((cargo) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: screenHeight * 0.13,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const NotificationDetail()),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.green.shade900, width: 6))),
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        margin: const EdgeInsets.only(
                                            bottom: 20, top: 15),
                                        child: Text(cargo.driverName)),
                                    Text(cargo.status),
                                  ],
                                ),
                                Text(cargo.plateNumber),
                                Text(cargo.Date)
                              ]),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
