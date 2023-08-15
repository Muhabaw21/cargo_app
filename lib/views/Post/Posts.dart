import 'dart:convert';
import 'dart:io';

import 'package:cargo/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../Components/Home_Page.dart';
import '../../constant/utils.dart';
import '../../localization/app_localizations.dart';
import '../../navigate/navigateBloc.dart';
import '../../navigate/navigatestateEvent.dart';
import '../../shared/custom-form.dart';
import '../../shared/customButton.dart';
import 'package:intl/intl.dart';
import '../../shared/failAlert.dart';
import '../../shared/storage_hepler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../Bottom_Navigation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CargoType {
  int id;
  String cargoType;

  CargoType({required this.id, required this.cargoType});

  factory CargoType.fromJson(Map json) {
    return CargoType(id: json['id'], cargoType: json['cargoType']);
  }
}

class Posts extends StatefulWidget {
  const Posts({super.key, AppLocalizations? localizations});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final _from = TextEditingController();
  final _to = TextEditingController();
  final _cargoType = TextEditingController();
  final _packaging = TextEditingController();
  final _weight = TextEditingController();
  final _price = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> registerCargo(String fileName) async {
    StorageHelper storageHelper = StorageHelper();
    String? accessToken = await storageHelper.getToken();
    try {
      const url = 'http://164.90.174.113:9090/Api/Cargo/PostCargo';
      print("Access Token: $accessToken");
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $accessToken';
        request.fields['from'] = _from.text;
        request.fields['to'] = _to.text;
        request.fields['date'] = _dateController.text;
        // Check  cargo type is not null or empty
        if (_cargoType.text != null && _cargoType.text.isNotEmpty) {
          request.fields['cargoType'] = _cargoType.text;
        } else {
          Fluttertoast.showToast(
            msg: 'Cargo type cannot be empty.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return;
        }
        request.fields['packaging'] = _packaging.text;
        request.fields['weight'] = _weight.text;
        request.fields['price'] = _price.text;
        // Check the file name is not null or empty
        if (fileName != null && fileName.isNotEmpty) {
          File file = File(fileName);
          print('File path: ${file.path}');
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'billOfLoading',
                file.path,
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: 'The file does not exist.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            return;
          }
        }
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print('Response status code: ${response.statusCode}');
        print('Response body: $responseBody');
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(responseBody);
          Fluttertoast.showToast(
            msg: jsonResponse['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to register cargo.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(178, 142, 22, 1),
            textColor: Colors.white,
            fontSize: 14.0,
          );
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'An error occurred while registering cargo.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  List<CargoType> _cargoTypes = [];
  CargoType? _selectedCargoType;

  @override
  void initState() {
    super.initState();
    _fetchCargoTypes();
  }

  Future<void> _fetchCargoTypes() async {
    try {
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();
      final response = await http.get(
        Uri.parse('http://164.90.174.113:9090/Api/Admin/All/CargoType'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cargoTypes = List.from(data['cargoTypes'])
              .map((e) => CargoType.fromJson(e))
              .toList();
        });
      } else {
        final errorMessage = 'Failed to fetch cargo types';
        showSnackBar(context, errorMessage);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print("Error occurred: $e");
      final errorMessage = 'Failed to fetch cargo types';
      showSnackBar(context, errorMessage);
      print('Error details: $e');
      // You can add more troubleshooting methods here
    }
  }

  List cargoTypesItems = [];
  String? selectedCargoType;
  validateCargoType(CargoType value) {
    return value == null ? 'Please select a cargo type' : null;
  }

  TextEditingController _dateController = TextEditingController();
  String? validateDate(String value) {
    if (value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 1)),
      ),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked.start) +
            ' to ' +
            DateFormat('yyyy-MM-dd').format(picked.end);
      });
    }
  }

  bool _isFocus = false;
  TextEditingController cargoTypeController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();
//e a function to pick a file
  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          _fileController.text = filePath;
        });
      }
    }
  }

  bool isPressed = true;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 247, 249),
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
          child: Center(
            child: Text(
              AppLocalizations.of(context)?.translate("Post Your Cargo Here") ??
                  "Post Your Cargo Here",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFieldForm(
                  hintText:
                      AppLocalizations.of(context)?.translate("From") ?? "From",
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                  textController: _from,
                  obscureText: false,
                  hintTextStyle: TextStyle(
                    letterSpacing: 1.0,
                    wordSpacing: 2.0,
                    color: _isFocus ? Colors.red : Colors.grey,
                    // ... other styles
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate("Please enter your departure") ??
                          "Please enter your departure";
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldForm(
                  
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                  hintText:
                      AppLocalizations.of(context)?.translate("To") ?? "To",
                  textController: _to,
                  obscureText: false,
                  hintTextStyle: TextStyle(
                    letterSpacing: 1.0,
                    wordSpacing: 2.0,
                    color: _isFocus ? Colors.green : Colors.grey,
                    // ... other styles
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate("Please enter your destination") ??
                          "Please enter your destination";
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: AppLocalizations.of(context)
                            ?.translate("Select a date") ??
                        "Select a date",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDateRange(context),
                    ),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate('Please select a  date') ??
                          "Please select a date";
                    }
                    return null;
                  },
                  // validator: _validateDate,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _cargoType,
                  readOnly: true, // To prevent opening the keyboard
                  onTap: () async {
                    CargoType? selectedValue = await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 300, // set the width as desired
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _cargoTypes.map((CargoType cargo) {
                                return ListTile(
                                  title: Text(cargo.cargoType),
                                  onTap: () {
                                    Navigator.of(context).pop(cargo);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );

                    if (selectedValue != null) {
                      setState(() {
                        _selectedCargoType = selectedValue;
                        _cargoType.text = selectedValue.cargoType;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: AppLocalizations.of(context)
                            ?.translate("Select Cargo Type") ??
                        "Select Cargo Type",
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.expand_more_rounded),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate('Please select a cargo type') ??
                          "Please select a cargo type";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _fileController,
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: AppLocalizations.of(context)
                            ?.translate("Select a bill file") ??
                        "Select a bill file",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.attach_file_rounded),
                      onPressed: () async {
                        await pickFile();
                      },
                    ),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate('Select a bill file') ??
                          "Select a bill file";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldForm(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                  hintText: AppLocalizations.of(context)?.translate("Weight") ??
                      "Weight",
                  textController: _weight,
                  hintTextStyle: TextStyle(
                    letterSpacing: 1.0,
                    wordSpacing: 2.0,
                    color: _isFocus ? Colors.green : Colors.grey,
                    // ... other styles
                  ), // ... other styl
                  obscureText: false,

                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate("Please enter your weight") ??
                          "Please enter your weight";
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFieldForm(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                  hintText:
                      AppLocalizations.of(context)?.translate("Packaging") ??
                          "Packaging",
                  textController: _packaging,
                  hintTextStyle: TextStyle(
                    letterSpacing: 1.0,
                    wordSpacing: 2.0,
                    color: _isFocus ? Colors.green : Colors.grey,
                    // ... other styles
                  ), // ... other styl
                  obscureText: false,

                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate("Please enter your package") ??
                          "Please enter your package";
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  onPressed: () {
                    registerCargo(_fileController.text);
                  },
                  text:
                      AppLocalizations.of(context)?.translate("Post") ?? "Post",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
