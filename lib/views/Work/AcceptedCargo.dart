import 'package:cargo/views/Work/ActiveWork.dart';
import 'package:cargo/Components/Home_Page.dart';
import 'package:cargo/shared/storage_hepler.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../Components/Noglow.dart';
import '../../localization/app_localizations.dart';
import '../../model/bill.dart';
import '../../model/cargo.dart';
import '../../shared/constant.dart';
import '../../shared/networkError.dart';

class AcceptedCargo extends StatefulWidget {
  final AppLocalizations? localizations;
  final int? id;
  @override
  const AcceptedCargo({Key? key, this.localizations, this.id})
      : super(key: key);

  @override
  _AcceptedCargoState createState() => _AcceptedCargoState();
}

class _AcceptedCargoState extends State<AcceptedCargo> {
  Future? futureCargoDrivers;
  List activeCargoStatus = [];
  List _searchResults = [];
  List _allCargos = [];

  bool _searching = false;
  Future fetchActiveCargos() async {
    try {
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();
      final response = await http.get(
        Uri.parse('http://164.90.174.113:9090/Api/Cargo/All/Cargos'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        },
      );
      print(response);
      if (response.statusCode == 200) {
        List cargoJson = json.decode(response.body)['cargos'];
        List<Cargo> activeCargos = cargoJson
            .map((cargo) => Cargo.fromJson(cargo))
            .where((cargo) => cargo.status == 'ACCEPTED')
            .toList();
        return activeCargos;
      } else {
        final message = json.decode(response.body)['error'];
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    } catch (e) {
      // Handle other errors
      if (e is http.ClientException &&
          e.message.contains('Connection reset by peer')) {
        Fluttertoast.showToast(
          msg: "Connection reset by peer",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        // Display an error message to the user or retry the operation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Connection reset by peer. Please try again.'),
              actions: [
                ElevatedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    // Retry the operation
                    fetchActiveCargos();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      print('Error in fetchActiveCargos(): $e');
      Alert(
        context: context,
        title: "Error",
        desc: "Failed to fetch data",
        type: AlertType.error,
      ).show();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CargoOWnerHomePage()),
      );
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchActiveCargos().then((cargos) {
        setState(() {
          _allCargos = cargos;
        });
      });
    }
  }

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List filteredCargos = [];

  Future<List<Cargo>> searchCargosByStatus() async {
    try {
      List<dynamic> cargos = await fetchActiveCargos();
      List<Cargo> filteredCargos = cargos
          .where((cargo) =>
              cargo.status.toLowerCase().contains(searchQuery.toLowerCase()) ||
              cargo.dropOff.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList()
          .cast<Cargo>();
      return filteredCargos;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to search cargos by status, destination and payment",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return [];
    }
  }

  bool isExpanded = false;
  List _data = [];
  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNav()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
          ),
          backgroundColor: Colors.white,
          title: Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: screenWidth * 0.1),
            height: 40,
            color: Colors.white,
            child: Center(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  searchCargosByStatus();
                },
                decoration: const InputDecoration(
                  hintText: 'Status & Destination',
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
        body: Center(
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: screenHeight,
                    child: FutureBuilder<List<Cargo>>(
                        future: searchCargosByStatus(),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const NetWorkError()
                              : snapshot.data!.isEmpty && searchQuery.isNotEmpty
                                  ? (searchQuery.length < 3 ||
                                          searchQuery.contains('dummy'))
                                      ? SizedBox(
                                          height: double.infinity,
                                          child: Center(
                                            child: Lottie.asset(
                                              'assets/images/noapidatas.json',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Lottie.asset(
                                            'assets/images/noapidatas.json',
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                  : snapshot.data!.isEmpty
                                      ? Center(
                                          child: Lottie.asset(
                                          'assets/images/noapidatas.json',
                                          fit: BoxFit.cover,
                                        ))
                                      : ScrollConfiguration(
                                          behavior: NoGlowScrollBehavior(),
                                          child: ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .padding
                                                        .bottom +
                                                    100),
                                            itemBuilder: (context, index) {
                                              Cargo cargo =
                                                  snapshot.data![index];
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: screenHeight * 0.2,
                                                  child: GestureDetector(
                                                    onTap: (() {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VehicleCargo(
                                                                      id: cargo
                                                                          .id)));
                                                    }),
                                                    child: Card(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200
                                                                    .withOpacity(
                                                                        0.7),
                                                                blurRadius: 8.0,
                                                                spreadRadius:
                                                                    2.0,
                                                                offset:
                                                                    const Offset(
                                                                  6, // Move to right 7.0 horizontally
                                                                  8, // Move to bottom 8.0 Vertically
                                                                ))
                                                          ],
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            ListTile(
                                                              title: Row(
                                                                children: [
                                                                  Text(
                                                                    cargo
                                                                        .pickUp,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          123,
                                                                          129,
                                                                          236),
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: 8,
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .trip_origin,
                                                                      size: 15,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          123,
                                                                          129,
                                                                          236),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        screenWidth *
                                                                            0.15,
                                                                    child:
                                                                        const Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        DottedLine(
                                                                          lineThickness:
                                                                              1.0,
                                                                          dashLength:
                                                                              4.0,
                                                                          dashColor:
                                                                              Colors.grey,
                                                                          dashGapRadius:
                                                                              2.0,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .local_shipping,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              123,
                                                                              129,
                                                                              236),
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                8),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(context)!.translate(cargo
                                                                            .dropOff) ??
                                                                        cargo
                                                                            .dropOff,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 15,
                                                              ),
                                                              child:
                                                                  const DottedLine(
                                                                lineThickness:
                                                                    1.0,
                                                                dashLength: 4.0,
                                                                dashColor:
                                                                    Colors.grey,
                                                                dashGapRadius:
                                                                    2.0,
                                                              ),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        ?.translate(
                                                                            "Cargo Status") ??
                                                                    "Cargo Status",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              trailing:
                                                                  SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.22,
                                                                child: Text(
                                                                  cargo.status,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .amber,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                        })))));
  }
}
