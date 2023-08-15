import 'package:flutter/material.dart';
import '../../shared/constant.dart';
import '../../shared/customButton.dart';

class Status extends StatefulWidget {
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool _isActivebutton2 = false;
  //change state of button
  void setActiveButton(bool isActive) {
    setState(() {
    });
  }

  void setActiveButton2(bool isActive) {
    setState(() {
      _isActivebutton2 = isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Stack(children: [
            Container(
              height: screenHeight * 0.25,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(85, 164, 240, 1),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      height: screenHeight * 0.06,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.09),
                      width: screenWidth * 0.13,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                child: Container(
              margin: EdgeInsets.only(top: 99),
              height: screenHeight * 0.22,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: screenHeight * 0.19,
                      width: screenWidth - 20,
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "Plate Number",
                                    style:TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(right: 20, top: 10),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "025462",
                                    style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 10),
                                      padding: const EdgeInsets.all(4.0),
                                      child: const Text(
                                        "Driver Name",
                                        style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      )),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 20, top: 10),
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Abinet",
                                        style:TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            right: 15,
            left: 15,
          ),
          width: screenWidth,
          height: screenHeight * 0.4,
          child: Card(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Row(
                  children: [
                    SizedBox(
                        width: screenWidth * 0.42,
                        child: CustomButton(text: "Load", onPressed: () {})),
                    SizedBox(
                        width: screenWidth * 0.42,
                        child: CustomButton(text: "UnLoad", onPressed: () {}))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: screenWidth * 0.42,
                        child: CustomButton(text: "Start", onPressed: () {})),
                    SizedBox(
                        width: screenWidth * 0.42,
                        child: CustomButton(text: "Cancel", onPressed: () {}))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: screenWidth * 0.42,
                        child: CustomButton(text: "Arrived", onPressed: () {})),
                    SizedBox(
                        width: screenWidth * 0.42,
                        child:
                            CustomButton(text: "Departure", onPressed: () {}))
                  ],
                ),
              ]),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
                width: screenWidth * 0.5,
                child: CustomButton(text: "Share", onPressed: () {})),
            SizedBox(
                width: screenWidth * 0.5,
                child: CustomButton(text: "Track", onPressed: () {}))
          ],
        ),
      ]),
    );
  }
}
