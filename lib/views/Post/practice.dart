import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../Components/Home_Page.dart';

class HistorySample extends StatefulWidget {
  const HistorySample({super.key});

  @override
  State<HistorySample> createState() => _HistorySampleState();
}

class _HistorySampleState extends State<HistorySample> {
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
                MaterialPageRoute(builder: (context) => CargoOWnerHomePage()));
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
                hintText: 'Driver Name or Plate No.',
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
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 8, right: 8),
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
          height: screenHeight * 0.18,
          child: ListTile(
            title: Container(
              margin: EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        const Text(
                          "Addis Ababa",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 123, 129, 236),
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
                              color: Color.fromARGB(255, 123, 129, 236)),
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
                                color: Color.fromARGB(255, 123, 129, 236),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.location_on,
                              size: 15, color: Colors.grey.shade300),
                        ),
                        Text(
                          "Djibouti",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "2023-06-10",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 30),
                            child: Text(
                              "2023-07-10",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    child: const Expanded(
                      child: DottedLine(
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.grey,
                        dashGapRadius: 2.0,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Cargo Status",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade500,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 252, 216, 214),
                      ),
                      child: const Center(
                        child: Text(
                          "New",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 255, 86, 74),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
