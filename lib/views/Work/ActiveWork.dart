import 'package:cargo/shared/customButton.dart';
import 'package:cargo/shared/storage_hepler.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import '../../Components/Noglow.dart';
import '../../constant/global_variables.dart';
import '../../localization/app_localizations.dart';
import '../../model/VehicleListForCargo.dart';
import '../../shared/constant.dart';
class VehicleCargo extends StatefulWidget {
  final int? id;
  @override
  const VehicleCargo({Key? key, this.id}) : super(key: key);
  @override
  State<VehicleCargo> createState() => _VehicleCargoState();
}

class _VehicleCargoState extends State<VehicleCargo> {
  Future? futureCargoDrivers;
  Future fetchCargos() async {
    try {
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();
      final response = await http.get(
          Uri.parse(
              'http://164.90.174.113:9090/Api/Cargo/All/CargoDrivers/${widget.id}'),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken",
          });
      print(response);
      if (response.body.contains('cargoDriversINFs')) {
        final data = jsonDecode(response.body);
        final cargoDriversList = data['cargoDriversINFs'] as List<dynamic>;
        final cargoDrivers = cargoDriversList.map((cargoDriverData) {
          return Cargo_Vehicle(
            id: cargoDriverData['id'],
            driver: cargoDriverData['driver'],
            driverState: cargoDriverData['driverState'] ?? "",
            driverID: cargoDriverData['driverID'],
            cargo: cargoDriverData['cargo'],
            vehicleOwner: cargoDriverData['vehicleOwner'],
            plateNumber: cargoDriverData['plateNumber'],
          );
        }).toList();
        return cargoDrivers;
      } // Handle connection timeout error
      else {
        Fluttertoast.showToast(
            msg: "Failed To load...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);

        Navigator.of(context, rootNavigator: true).pop();
        return [];
      }
    } catch (e) {
      print('Error in _fetchCargoDrivers(): $e');
      Fluttertoast.showToast(
          msg: "Failed To load...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
  List activeCargoStatus = [];
  @override
  void initState() {
    super.initState();
    fetchCargos().then((cargos) {
      setState(() {});
    });
  }
  TextEditingController searchController = TextEditingController();
  Future searchCargosByOwnerName(String status) async {
    try {
      List cargos = await fetchCargos();
      List filteredCargos = cargos
          .where((cargo) =>
              cargo.driver.toLowerCase().contains(status.toLowerCase()))
          .toList();
      return filteredCargos;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to search cargos by driver name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  bool isExpanded = false;
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
  Future<List<Map<String, dynamic>>> fetchData() async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();

    final response = await http.get(
        Uri.parse(
            'http://164.90.174.113:9090/Api/Admin/Cargo/DriversList/${widget.id}/UNLOAD'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        });
    final jsonResponse = jsonDecode(response.body);
    print('Response: $jsonResponse');
    final drivers = jsonResponse['drivers'].cast<Map<String, dynamic>>();
    print('Drivers: $drivers');
    return drivers;
  }
  Future<int> fetchDriversLength() async {
    List<Map<String, dynamic>> drivers = await fetchData();
    return drivers.length;
  }
  Future updateDriverState(List<Map<String, dynamic>> drivers) async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    final url =
        'http://164.90.174.113:9090/Api/Cargo/ConfirmDriverState/${widget.id}';
    final body = jsonEncode({
      'drivers': drivers,
    });

    final response = await http.post(Uri.parse(url), body: body, headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      "Authorization": "Bearer $accessToken",
    });
    final responseJson = jsonDecode(response.body);
    final message = responseJson['message'];
    print("Body: ${responseJson}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber.shade200,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber.shade200,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNav()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 162, 162, 162),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 254, 250),
          title: Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: screenWidth * 0.1),
            height: 80,
            color: const Color.fromARGB(255, 252, 254, 250),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchCargosByOwnerName(value).then((searchedCargos) {
                          setState(() {                         
                          });
                        }).catchError((error) {});
                      },
                      decoration: const InputDecoration(
                        hintText: 'Driver Name',
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: FutureBuilder<int>(
                        future: fetchDriversLength(),
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError) {
                            return const Text('');
                          } else {
                            int driversLength = snapshot.data ?? 0;
                            return SizedBox(
                              height: screenHeight * 0.4,
                              child: Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.05,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(178, 142, 22, 1),
                                    ),
                                    padding: const EdgeInsets.all(11),
                                    child: Text(driversLength.toString(),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const Text(
                                    "Confirm",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 30),
            child: FutureBuilder(
                future: searchCargosByOwnerName(searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.08,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                    color: GlobalVariables.primaryColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Vehicle Owner",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: GlobalVariables.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Driver",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: GlobalVariables.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Plate Number",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: GlobalVariables.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Notifications",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: GlobalVariables.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RefreshIndicator(
                            onRefresh: () async {
                              final drivers = await fetchData();
                              await updateDriverState(drivers);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 18),
                              height: screenHeight * 0.53,
                              child: Stack(
                                children: [
                                  ScrollConfiguration(
                                    behavior: NoGlowScrollBehavior(),
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        Cargo_Vehicle cargoDriver =
                                            snapshot.data![index];
                                        return InkWell(
                                          onTap: () {
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            height: screenHeight * 0.1,
                                            child: Card(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: const Border(
                                                    left: BorderSide(
                                                      color: GlobalVariables
                                                          .primaryColor,
                                                      width: 3,
                                                    ),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200
                                                            .withOpacity(0.7),
                                                        blurRadius: 8.0,
                                                        spreadRadius: 2.0,
                                                        offset: const Offset(
                                                          6, // Move to right 7.0 horizontally
                                                          8, // Move to bottom 8.0 Vertically
                                                        ))
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                        title: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            cargoDriver
                                                                .vehicleOwner,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: GlobalVariables
                                                                  .primaryColor,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            cargoDriver.driver,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: GlobalVariables
                                                                  .primaryColor,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            cargoDriver
                                                                .plateNumber,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: GlobalVariables
                                                                  .primaryColor,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        cargoDriver.driverState ==
                                                                "UNLOAD"
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height:
                                                                    screenHeight *
                                                                        0.02,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          178,
                                                                          142,
                                                                          22,
                                                                          1),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(11),
                                                              )
                                                            : cargoDriver
                                                                        .driverState ==
                                                                    "UNLOADED"
                                                                ? Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height:
                                                                        screenHeight *
                                                                            0.02,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            11),
                                                                  )
                                                                : Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height:
                                                                        screenHeight *
                                                                            0.02,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            11),
                                                                  ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 100,
                                    right: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FloatingActionButton(
                                          backgroundColor:
                                              GlobalVariables.primaryColor,
                                          onPressed: () async {
                                            final pdf = pw.Document();
                                            pdf.addPage(
                                              pw.MultiPage(
                                                pageFormat: PdfPageFormat.a4,
                                                build: (pw.Context context) => [
                                                  pw.Header(
                                                      text: 'My Cargos',
                                                      level: 0),
                                                  pw.Table.fromTextArray(
                                                    headers: [
                                                      '#',
                                                      'Vehicle Owner Name',
                                                      'Driver Name',
                                                      'Plate Number'
                                                    ],
                                                    data: List<
                                                        List<String>>.generate(
                                                      snapshot.data!.length > 5
                                                          ? 5
                                                          : snapshot
                                                              .data!.length,
                                                      (index) => [
                                                        (index + 1).toString(),
                                                        snapshot.data![index]
                                                            .vehicleOwner,
                                                        snapshot.data![index]
                                                            .driver,
                                                        snapshot.data![index]
                                                            .plateNumber,
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            final bytes = await pdf.save();
                                            await Share.file(
                                              'My Cargos',
                                              'my_cargos.pdf',
                                              bytes.buffer.asUint8List(),
                                              'application/pdf',
                                            );
                                          },
                                          child: const Icon(
                                            Icons.share,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: CustomButton(
                                onPressed: () async {
                                  try {
                                    final drivers = await fetchData();
                                    await updateDriverState(drivers);
                                  } catch (e) {
                                    print('Error: $e');
                                  }
                                },
                                text: AppLocalizations.of(context)
                                        ?.translate("Confirm Drivers") ??
                                    "Confirm Drivers"),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Center(
                    child: FutureBuilder(
                      future: Future.delayed(Duration(seconds: 10),
                          () => _checkInternetConnection()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return Container(
                              alignment: Alignment.center,
                              height: screenHeight * 0.13,
                              width: screenWidth * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.grey.shade200.withOpacity(0.7),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                      offset: const Offset(
                                        6,
                                        8,
                                      ))
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text('Network Error',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade500,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'No Network. Connect your device to internet or mobile data',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ));
                        }
                      },
                    ),
                  );
                })));
  }
}
