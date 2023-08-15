import 'dart:async';
import 'dart:convert';
import 'package:cargo/constant/global_variables.dart';
import 'package:cargo/localization/app_localizations.dart';
import 'package:cargo/shared/constant.dart';
import 'package:cargo/shared/customButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../shared/custom-form.dart';
import 'package:hive/hive.dart';
import '../../shared/storage_hepler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path_provider/path_provider.dart';
import 'resetPassword.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  Box<String>? logoBox;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
// Initialize Hive and open the logoBox
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

  void initState() {
    super.initState();
    initHive();
  }

  bool _isFocus = false;
  void _showSweetAlert(BuildContext context, AlertType alertType, String title,
      String description) {
    Alert(
      context: context,
      type: alertType,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ResetPassword()),
            )
          },
          width: 120,
        ),
      ],
    ).show();
  }

  generatePin(String cargoOwnerPhone) async {
    const url = 'http://164.90.174.113:9090/Api/User/GeneratePIN';

    // Define your request data as a Map
    Map requestData = {
      'phoneNumber': "${cargoOwnerPhone}",
    };
    print(requestData);

    print(requestData);

    print("********************************");
    print('Token: $requestData');
    print("********************************");
    try {
      String body = json.encode(requestData);
      StorageHelper storageHelper = StorageHelper();
      String? accessToken = await storageHelper.getToken();
      // Make the request and handle the response
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        final response = await http.post(
          Uri.parse(url),
          body: body,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          },
        );
        print(response.body);
        print(response.statusCode);
        final Map jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          _showSweetAlert(
              context, AlertType.success, 'Success', jsonResponse['message']);
        } else {
          _showSweetAlert(
              context, AlertType.error, 'Error', jsonResponse['message']);
        }
      }
    } catch (e) {
      _showSweetAlert(context, AlertType.error, 'Error',
          'An error occurred, please check your internet connection.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Center(
                child: Container(
                  color: kBackgroundColor,
                  margin: EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: kBackgroundColor,
                    child: FutureBuilder(
                      future: storeLogoToHive(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Text("");
                        String? logo = logoBox?.get('logo');
                        if (logo != null) {
                          return Image.network(
                            logo,
                          );
                        } else {
                          return Text('Bazra Technology Group',
                              style: TextStyle(
                                  color: GlobalVariables.primaryColor));
                        }
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)?.translate("Forget Password") ??
                      "Forget Password",
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    color: GlobalVariables.primaryColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 45),
                child: Text(
                  AppLocalizations.of(context)?.translate(
                          "Enter your phone number to get a verification code.") ??
                      "Enter your phone number to get a verification code.",
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontFamily: 'Roboto',
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
              ),
              CustomTextFieldForm(
                textStyle: const TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: "Roboto"),
                hintText:
                    AppLocalizations.of(context)?.translate("Phone Number") ??
                        "Phone Number",
                hintTextStyle: const TextStyle(
                  letterSpacing: 1.0,
                  wordSpacing: 2.0,
                  color: Colors.grey,
                ),
                textController: _phoneController,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate("Please enter your phone number") ??
                        "Please enter your phone number";
                  }
                },
                obscureText: false,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.translate(
                            "You will receive a 5 digit verification code.") ??
                        "You will receive a 5 digit verification code.",
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      color: Colors.black54,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              CustomButton(
                onPressed: () async {
                  await generatePin(
                    _phoneController.text,
                  );
                },
                text:
                    AppLocalizations.of(context)?.translate('Reset') ?? "Reset",
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
