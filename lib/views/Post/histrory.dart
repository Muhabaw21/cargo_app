import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Components/Noglow.dart';
import '../../localization/app_localizations.dart';
import '../../model/cargo.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../shared/loading.dart';
import '../../shared/networkError.dart';
import '../../shared/storage_hepler.dart';
import '../Bottom_Navigation.dart';
import 'historyDetail.dart';

class CargoHistory extends StatefulWidget {
  String? plateNumber;
  final AppLocalizations? localizations;
  CargoHistory({Key? key, this.localizations}) : super(key: key);
  @override
  _CargoHistoryState createState() => _CargoHistoryState();
}

class _CargoHistoryState extends State {
  Future fetchCargos() async {
    if (!mounted) return;
    try {
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();
      final response = await http.get(
          Uri.parse('http://164.90.174.113:9090/Api/Cargo/All/Cargos'),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken",
          });
      if (response.statusCode == 200) {
        List cargoJson = json.decode(response.body)['cargos'];
        return cargoJson.map((cargo) => Cargo.fromJson(cargo)).toList();
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
    } on SocketException catch (_) {
    } catch (error) {
      if (error is http.ClientException &&
          error.message.contains('Connection reset by peer')) {
        Fluttertoast.showToast(
          msg: "Connection reset by peer",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Connection reset by peer. Please try again.'),
              actions: [
                ElevatedButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    // Retry the operation
                    fetchCargos();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future? futureCargos;
  TextEditingController searchController = TextEditingController();
  List _searchResults = [];
  List _allCargos = [];
  @override
  void initState() {
    super.initState();
    futureCargos = fetchCargos().then((cargos) {
      if (mounted) {
        setState(() {
          _allCargos = cargos;
        });
        searchCargosByStatus();
      }
    });
  }

  String searchQuery = '';
  List filteredCargos = [];

  Future<List<Cargo>> searchCargosByStatus() async {
    try {
      List<dynamic> cargos = await fetchCargos();
      List<Cargo> filteredCargos = cargos
          .where((cargo) =>
              cargo.status.toLowerCase().contains(searchQuery.toLowerCase()) ||
              cargo.pickUp.toLowerCase().contains(searchQuery.toLowerCase()) ||
              cargo.dropOff.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList()
          .cast<Cargo>();
      return filteredCargos;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to search cargos by status, destination and departure",
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

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  bool isPressed = true;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
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
                      hintText: 'Status, Destination, Departure',
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
                              return (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                  ? const NetWorkError()
                                  : (snapshot.data!.isEmpty &&
                                          searchQuery.isNotEmpty)
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
                                              ),
                                            )
                                          : ScrollConfiguration(
                                              behavior: NoGlowScrollBehavior(),
                                              child: ListView.builder(
                                                itemCount:
                                                    snapshot.data!.length,
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .padding
                                                          .bottom +
                                                      300,
                                                ),
                                                itemBuilder: (context, index) {
                                                  Cargo cargo =
                                                      snapshot.data![index];
                                                  return ListTile(
                                                    title: SizedBox(
                                                      height:
                                                          screenHeight * 0.22,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  cargoHistoryDetail(
                                                                cargoId:
                                                                    cargo.id,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Card(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10),
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200
                                                                      .withOpacity(
                                                                          0.7),
                                                                  blurRadius:
                                                                      8.0,
                                                                  spreadRadius:
                                                                      2.0,
                                                                  offset:
                                                                      const Offset(
                                                                    6,
                                                                    8,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            child: ListTile(
                                                              title: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.25,
                                                                            child:
                                                                                Text(
                                                                              cargo.pickUp,
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                color: Color.fromARGB(255, 123, 129, 236),
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(
                                                                              left: 8,
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.trip_origin,
                                                                              size: 15,
                                                                              color: Color.fromARGB(255, 123, 129, 236),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.1,
                                                                            child:
                                                                                const Stack(
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
                                                                            margin:
                                                                                const EdgeInsets.only(right: 8),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Icon(Icons.location_on,
                                                                                size: 15,
                                                                                color: Colors.grey.shade300),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.25,
                                                                            child:
                                                                                Text(
                                                                              cargo.dropOff,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.grey.shade600,
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      subtitle: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              cargo.date,
                                                                              style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: Colors.grey.shade600,
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                        top: 15,
                                                                      ),
                                                                      child:
                                                                          const DottedLine(
                                                                        lineThickness:
                                                                            1.0,
                                                                        dashLength:
                                                                            4.0,
                                                                        dashColor:
                                                                            Colors.grey,
                                                                        dashGapRadius:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                    ListTile(
                                                                      title:
                                                                          Text(
                                                                        "Cargo Status",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade500,
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          SizedBox(
                                                                        width: screenWidth *
                                                                            0.22,
                                                                        child:
                                                                            Text(
                                                                          cargo
                                                                              .status,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.amber,
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                            }))))));
  }
}
