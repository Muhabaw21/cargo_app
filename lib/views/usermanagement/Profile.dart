import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../Components/Noglow.dart';
import '../../constant/global_variables.dart';
import '../../constant/utils.dart';
import '../../localization/localization_bloc.dart';
import '../../localization/localization_event.dart';
import '../../model/CargoOwnerInfo.dart';
import '../../services/api_service.dart';
import '../../shared/cargoInfo.dart';
import '../../shared/cargoInfo.dart';
import '../../shared/cargoPhone.dart';
import '../../shared/constant.dart';
import '../../shared/networkError.dart';
import '../../shared/storage_hepler.dart';
import 'ProfileEdit.dart';
import 'changePassword.dart';
import 'languages.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  String? companyName;
  Profile({super.key, this.companyName});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String ownerPic = "";
  bool isLoading = true;

  final AuthService authService = AuthService();
  Future<String> _fetchLogo() async {
    var client = http.Client();
    final storage = new FlutterSecureStorage();
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
        Uri.parse('http://164.90.174.113:9090/Api/Admin/LogoandAvatar'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Map<String, dynamic> data = json.decode(response.body);
      await storage.write(key: "ownerpic", value: data["avatar"].toString());

      ownerPic = (await storage.read(key: 'ownerpic'))!;
      return data["avatar"];
    } else {
      throw Exception('Failed to load image');
    }
  }

  PickedFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  String name = '';
  String phone = '';
  void takePicture(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _pickedImage = pickedFile != null ? PickedFile(pickedFile.path) : null;
    });
  }

  Map<String, dynamic> responseData = {};
  Future<void> cargoOwnerInfo({required BuildContext context}) async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();

    http.Response response = await http.get(
      Uri.parse('$uri/Api/CargoOwner/Info'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        responseData = json.decode(response.body) as Map<String, dynamic>;
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getCargoInfo();
      getPhoneNumber();
      cargoOwnerInfo(context: context);
    }
  }

  Future<void> getCargoInfo() async {
    CargoInfo cargoInfo = CargoInfo();
    String? cargoName = await cargoInfo.getCargoInfo();

    setState(() {
      name = cargoName ?? '';
    });
  }

  Future<void> getPhoneNumber() async {
    CargoPhoneNumber phoneNum = CargoPhoneNumber();
    String? cargoPhone = await phoneNum.getCargoPhoneNumber();

    setState(() {
      phone = cargoPhone ?? '';
    });
  }

  final AuthService _authService = AuthService();
  CargoOwnerInfo? _cargoOwnerInfo;

  Widget buildLanguageDropdown(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final localeBloc = context.read<LocaleBloc>();
    bool isPressed = true;
    return Container(
      width: screenWidth * 0.09,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular((6))),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: Colors.grey.shade200,
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
            : null,
      ),
      child: DropdownButton<Locale>(
        value: localeBloc.state.locale,
        underline: Container(),
        iconSize: 30,
        items: <Locale>[
          Locale('en', ''),
          Locale('am', ''),
        ].map<DropdownMenuItem<Locale>>((Locale value) {
          return DropdownMenuItem<Locale>(
            value: value,
            child: Text(value.languageCode),
          );
        }).toList(),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            localeBloc.add(ChangeLocale(newLocale));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final cargoOwnerInfo = responseData!['cargoOwnerINF'];
    final businessINF = responseData!['businessINF'];
    final address = responseData!['address'];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: screenHeight * 0.15,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Stack(
                    children: [
                      Positioned(
                          left: screenWidth * 0.35,
                          height: screenHeight * 0.15,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        cargoOwnerInfo?['pic'] ?? ''),
                                  ),
                                  Positioned(
                                    left: 59,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: screenHeight * 0.07),
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext contex) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Choose Option',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: GlobalVariables
                                                            .primaryColor,
                                                      )),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(children: [
                                                      InkWell(
                                                          onTap: () {
                                                            takePicture(
                                                                ImageSource
                                                                    .camera);
                                                          },
                                                          splashColor:
                                                              GlobalVariables
                                                                  .primaryColor,
                                                          child: Row(
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons.camera,
                                                                  color: GlobalVariables
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              Text('Camera',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .grey[
                                                                          500]))
                                                            ],
                                                          )),
                                                      InkWell(
                                                          onTap: () {
                                                            takePicture(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          splashColor:
                                                              GlobalVariables
                                                                  .primaryColor,
                                                          child: Row(
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .browse_gallery,
                                                                  color: GlobalVariables
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              Text('Galley',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .grey[
                                                                          500]))
                                                            ],
                                                          )),
                                                      InkWell(
                                                          onTap: () {},
                                                          splashColor:
                                                              GlobalVariables
                                                                  .primaryColor,
                                                          child: Row(
                                                            children: [
                                                              const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .remove_circle,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Text('Remove',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                              .grey[
                                                                          500]))
                                                            ],
                                                          )),
                                                    ]),
                                                  ),
                                                );
                                              });
                                        },
                                        elevation: 10,
                                        fillColor: GlobalVariables.primaryColor,
                                        shape: const CircleBorder(),
                                        child: const Icon(Icons.add_a_photo),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: screenWidth,
                  height: screenHeight * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text("Region"),
                        trailing: Text("${address?['subcity'] ?? 'N/A'}"),
                      ),
                      ListTile(
                        title: Text("Business Name"),
                        trailing:
                            Text("${businessINF?['businessName'] ?? 'N/A'}"),
                      ),
                      ListTile(
                        title: Text("Company Name"),
                        trailing:
                            Text("${cargoOwnerInfo?['ownerName'] ?? 'N/A'}"),
                      ),
                      ListTile(
                        title: Text("Phone Number"),
                        trailing:
                            Text("${cargoOwnerInfo?['phoneNumber'] ?? 'N/A'}"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEdit(
                                  ownerAvatar: cargoOwnerInfo?['pic'],
                                  companyName: cargoOwnerInfo?['ownerName'],
                                  phoneNumber: cargoOwnerInfo?['phoneNumber'],
                                  businessName: businessINF?['businessName'],
                                  businessSector:
                                      businessINF?['businessSector'],
                                  businessType: businessINF?['businessType'],
                                  region: address?['region'],
                                  subcity: address?['subcity'],
                                  specificLocation:
                                      address?['specificLocation']),
                            ),
                          );
                        },
                        child: ListTile(
                            title: Text("Edit Profile"),
                            trailing: const Icon(Icons.keyboard_arrow_right)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageListItem()),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight *
                            0.035, // Increase the vertical padding
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: screenWidth * 0.08,
                                width: screenWidth * 0.08,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(252, 221, 244, 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.language_sharp),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Text(
                                'Language',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  height: screenHeight * 0.35,
                  width: screenWidth,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangePassword()),
                          );
                        },
                        leading: Container(
                          height: screenWidth * 0.08,
                          width: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(201, 252, 248, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.lock_outline),
                        ),
                        title: const Text(
                          'Change password',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                                height: screenWidth * 0.08,
                                width: screenWidth * 0.08,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 245, 210, 1),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Icon(Icons.help)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: screenWidth * 0.3,
                                  child: const Text(
                                    "Help",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.37),
                                child: Icon(Icons.keyboard_arrow_right)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                                height: screenWidth * 0.08,
                                width: screenWidth * 0.08,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(201, 252, 248, 1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.settings)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: screenWidth * 0.3,
                                  child: const Text(
                                    "Setting",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                            Container(
                                margin:
                                    EdgeInsets.only(left: screenWidth * 0.37),
                                child: const Icon(Icons.keyboard_arrow_right)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // Other widgets in the row
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Cargo_login()),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
