import 'package:cargo/shared/customAppbar.dart';
import 'package:cargo/shared/customButton.dart';
import 'package:cargo/views/Notification/Notification.dart';
import 'package:flutter/material.dart';
import '../../model/post.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({super.key});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

final List<ListItem> items = [
  ListItem(
      driverName: 'Putin',
      plateNumber: ' 003221',
      Date: "09-05-2023",
      isExpanded: false,
      status: "start"),
];

class _NotificationDetailState extends State<NotificationDetail> {
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
                  MaterialPageRoute(builder: (context) => Notifications()));
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
              child: Text(
                "Notification Detail",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Column(
                  children: items.map((detail) {
                    return Container(
                      height: screenHeight * 0.4,
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 16.0, color: Colors.green.shade900),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text("Driver Name"),
                              trailing: Text(detail.driverName),
                            ),
                            ListTile(
                              title: const Text("Plate Number"),
                              trailing: Text(detail.plateNumber),
                            ),
                            ListTile(
                              title: const Text("Notification"),
                              trailing: Text(detail.status),
                            ),
                            const ListTile(
                              title: Text(
                                  "Vehicle Start it journey from Addis Ababa at 09-05-2023 at 5:30"),
                            ),
                          ],
                        ),
                      )),
                    );
                  }).toList(),
                ),
                Container(
                    margin: EdgeInsets.only(top: 130),
                    child: CustomButton(onPressed: () {}, text: "Approve"))
              ],
            ),
          ),
        ));
  }
}
