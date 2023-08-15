import 'dart:convert';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../constant/global_variables.dart';
import '../localization/app_localizations.dart';
import 'package:hive/hive.dart';
import '../shared/cargoInfo.dart';
import '../shared/storage_hepler.dart';
import '../views/Bill/BillCargo.dart';
import '../views/Post/Post_Navigation.dart';
import '../views/Notification/Notification.dart';
import '../views/Report/Report.dart';
import '../views/Work/Work_Navigation.dart';

class CargoOWnerHomePage extends StatefulWidget {
  int? index;

  CargoOWnerHomePage({super.key, this.index});

  @override
  State<CargoOWnerHomePage> createState() => _CargoOWnerHomePageState();
}

class _CargoOWnerHomePageState extends State<CargoOWnerHomePage> {
  DateTime pre_backprees = DateTime.now();
  // Initialize Hive and open the logoBox
  Box<String>? logoBox;
  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<String>('logoBox');
    logoBox = Hive.box<String>('logoBox');
  }

// Call initHive before using the fetchImage function

  Future<String> fetchImage() async {
    var client = http.Client();
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();

    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.get(
          Uri.parse('http://164.90.174.113:9090/Api/Admin/LogoandAvatar'),
          headers: requestHeaders);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        Map<String, dynamic> data = json.decode(response.body);
        return data["logo"];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image'),
          ),
        );
        return '';
      }
    } on Exception catch (e) {
      if (e is ArgumentError) {
        Fluttertoast.showToast(
            msg: "Check your internet Connection and try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
      print('Error occurred: $e');
      return '';
    }
  }

  Future<void> storeImageInHive() async {
    await Hive.openBox<String>('imageBox');
    final imageBox = Hive.box<String>('imageBox');
    final imageUrl = await fetchImage();
    imageBox.put('imageUrl', imageUrl);
  }

  Future<void> storeLogoToHive() async {
    String logo = await fetchImage();

    if (logo.isNotEmpty) {
      logoBox?.put('logo', logo);
      print('Logo stored in Hive: $logo');
    } else {
      print('Failed to store logo in Hive');
    }
  }

  String name = '';

  @override
  void initState() {
    super.initState();
    getCargoInfo();
    initHive();
  }

  Future<void> getCargoInfo() async {
    CargoInfo cargoInfo = CargoInfo();
    String? cargoName = await cargoInfo.getCargoInfo();
    setState(() {
      name = cargoName ?? '';
    });
  }

  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backprees);
        final canEXit = timegap >= const Duration(seconds: 2);
        pre_backprees = DateTime.now();
        if (canEXit) {
          final snack = SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                padding: const EdgeInsets.all(8),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular((6))),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)
                            ?.translate("Press Back Again To Exit") ??
                        "Press Back Again To Exit",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 246, 247, 249),
          body: Column(
            children: [
              Container(
                height: screenHeight * 0.07,
                margin: EdgeInsets.only(top: screenHeight * 0.055),
                // color: Colors.white,
                child: Row(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: FutureBuilder(
                            future: storeLogoToHive(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) return Text("");
                              String? logo = logoBox?.get('logo');
                              if (logo != null) {
                                return Image.network(
                                  logo,
                                );
                              } else {
                                return const Text('Logo not available');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: screenWidth * 0.07,
                        height: screenHeight * 0.08,
                        margin: EdgeInsets.only(
                          left: screenWidth * 0.6,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Notifications()),
                            );
                          },
                          child: const Icon(
                            Icons.notifications,
                            size: 30,
                            color: GlobalVariables.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black26,
                          Color.fromRGBO(250, 164, 246, 0.7),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(8.0),
                    height: screenHeight * 0.23,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 90, top: 10),
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.translate("Welcome Back ") ??
                                    "Welcome Back",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 13, left: 10),
                              child: Text(
                                "$name",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: screenHeight * 0.12, left: 20, right: 20),
                      height: screenHeight * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SizedBox(
                          height: screenHeight * 0.12,
                          child: FaIcon(
                            FontAwesomeIcons.boxOpen,
                            size: 60,
                            color: Color.fromRGBO(178, 142, 22, 1),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 20),
                  child: GridView(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    // ignore: sort_child_properties_last
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Post_BottomNav()));
                          },
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: 
                                      [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: Offset(4, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4, -4),
                                            blurRadius: 25,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                  ),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    margin: EdgeInsets.only(top: 12),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Icon(
                                      Icons.local_shipping,
                                      size: 50,
                                      color: Color.fromRGBO(178, 142, 22, 1),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.translate("Post Cargo Work") ??
                                          "Post Cargo Work",
                                      style: const TextStyle(
                                        color: Color.fromRGBO(178, 142, 22, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CargoBill()));
                          },
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: isPressed
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: Offset(4, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4, -4),
                                            blurRadius: 25,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    // height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Icon(
                                      Icons.attach_money_rounded,
                                      size: 50,
                                      color: Color.fromRGBO(178, 142, 22, 1),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.translate("Bill") ??
                                          "Bill",
                                      style: const TextStyle(
                                        color: Color.fromRGBO(178, 142, 22, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkResponse(
                          onTap: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Work_BottomNav()));
                          }),
                          child: Ink(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: isPressed
                                        ? [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(4, 4),
                                              blurRadius: 15,
                                              spreadRadius: 1,
                                            ),
                                            const BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-4, -4),
                                              blurRadius: 25,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null),
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,

                                      margin: EdgeInsets.only(top: 12),
                                      //height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Icon(
                                        Icons.work,
                                        size: 50,
                                        color: Color.fromRGBO(178, 142, 22, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Text(
                                          AppLocalizations.of(context)
                                                  ?.translate("Active Work") ??
                                              "Active Work",
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  178, 142, 22, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Report()));
                          },
                          child: AnimatedContainer(
                              //padding: EdgeInsets.only(bottom: _padding),
                              duration: Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: isPressed
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: Offset(4, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                          ),
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-4, -4),
                                            blurRadius: 25,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    margin: EdgeInsets.only(top: 12),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Icon(
                                      Icons.insert_chart_outlined_rounded,
                                      color: Color.fromRGBO(178, 142, 22, 1),
                                      size: 50,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.translate('Report') ??
                                          "Report",
                                      style: const TextStyle(
                                        color: Color.fromRGBO(178, 142, 22, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.8),
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
