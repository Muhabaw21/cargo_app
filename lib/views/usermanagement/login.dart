import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:cargo/shared/constant.dart';
import 'package:cargo/views/usermanagement/signup.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../constant/global_variables.dart';
import '../../constant/utils.dart';
import '../../localization/app_localizations.dart';
import '../../localization/localization_bloc.dart';
import '../../localization/localization_event.dart';
import '../../services/api_service.dart';
import '../../shared/custom-form.dart';
import '../../shared/storage_hepler.dart';
import 'package:path_provider/path_provider.dart';
import 'forgetPassword.dart';

class Cargo_login extends StatefulWidget {
  const Cargo_login({super.key});

  @override
  State<Cargo_login> createState() => _Cargo_loginState();
}

class _Cargo_loginState extends State<Cargo_login> {
  final _signInFormKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  String? ownerPic;
  Box<String>? logoBox;
  bool _isLoading = true;
  List<String> _data = [];
  String? phoneNumber;
  bool _isFocused = false;

  void signInUser() async {
    if (_signInFormKey.currentState!.validate()) {
      _signInFormKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authService.signInUser(
          context: context,
          password: _passwordController.text,
          username: _username.text,
        );
      } catch (e) {
        print("Error occurred while signing in: $e");
        showSnackBar(context, "An error occurred while signing in");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
    getPhoneNumberSync().then((value) {
      setState(() {
        phoneNumber = value;
        _username.text = phoneNumber ?? '';
      });
    });
    initHive();
  }
  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<String>('logoBox');
    logoBox = Hive.box<String>('logoBox');
  }
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
      // ignore: avoid_print
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
  bool isLoading = false;
  Widget buildLanguageDropdown(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final localeBloc = context.read<LocaleBloc>();
    bool isPressed = true;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.3,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton2<Locale>(
          hint: Text(
            AppLocalizations.of(context)?.translate('Select Language') ?? '',
          ),
          value: localeBloc.state.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeBloc.add(ChangeLocale(newLocale));
            }
          },
          underline: null,
          items: [
            DropdownMenuItem(
              value: Locale('en', ''),
              child: Text(
                AppLocalizations.of(context)?.translate('English') ?? 'English',
              ),
            ),
            DropdownMenuItem(
              value: Locale('am', ''),
              child: Text(
                AppLocalizations.of(context)?.translate('Amharic') ?? 'Amharic',
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String?> getPhoneNumberSync() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 50, left: 240),
                child: buildLanguageDropdown(context)),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
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
                        return const Text(
                          '',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20,
                            color: GlobalVariables.primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromRGBO(178, 142, 22,
                                1), // Replace with your desired color
                            decorationThickness:
                                2.0, // Adjust the thickness of the underline
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: screenHeight - 30,
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 30),
                child: Form(
                  key: _signInFormKey,
                  child: Column(children: [
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10, bottom: 40),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top:
                                  5.0), // Adjust the top margin of the underline
                          child: Container(
                            margin: EdgeInsets.only(bottom: 40),
                            child: Text(
                              "Login".toUpperCase(),
                              style: const TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                color: GlobalVariables.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Color.fromRGBO(178, 142, 22,
                                    1), // Replace with your desired color
                                decorationThickness:
                                    2.0, // Adjust the thickness of the underline
                              ),
                            ),
                          ),
                        )),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(AppLocalizations.of(context)
                              ?.translate("Mobile Number") ??
                          "Mobile Number"),
                    ),
                    CustomTextFieldForm(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Roboto"),
                      hintText: '',
                      textController: _username,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)?.translate(
                                  'Please enter your phone number') ??
                              "Please enter your phone number";
                        }
                      },
                      obscureText: false,
                      hintTextStyle: TextStyle(
                        letterSpacing: 1.0,
                        wordSpacing: 2.0,
                        color: _isFocused ? Colors.green.shade700 : Colors.grey,
                        // ... other styles
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                          AppLocalizations.of(context)?.translate("Password") ??
                              "Password"),
                    ),
                    CustomTextFieldForm(
                      hintText: '',
                      textController: _passwordController,
                      isPassword: true,
                      textStyle: TextStyle(fontSize: 16),
                      onChanged: (value) {
                        print("password changed: $value");
                      },
                      obscureText: true,
                      showSuffixIcon: true,
                      hintTextStyle: TextStyle(
                        letterSpacing: 1.0,
                        wordSpacing: 2.0,
                        color: _isFocused ? Colors.red : Colors.grey,
                        
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)
                                  ?.translate('Please enter a company name') ??
                              "Please enter a company name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Forget()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 25, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.translate("Forgot Password?") ??
                                  "Forgot Password",
                              style: const TextStyle(
                                fontSize: 15,
                                color: GlobalVariables.primaryColor,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                    ElevatedButton(
                      onPressed: signInUser,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(178, 142, 22, 1),
                        onPrimary: Colors.white,
                        textStyle: TextStyle(fontSize: 20.0),
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: 8),
                          Text(
                            isLoading
                                ? AppLocalizations.of(context)
                                        ?.translate('Please Wait') ??
                                    "Please Wait"
                                : AppLocalizations.of(context)
                                        ?.translate('Login')
                                        ?.toUpperCase() ??
                                    "Login".toUpperCase(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 10),
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.translate("Don't have an account?") ??
                                    "Don't have an account",
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  wordSpacing: 1.0,
                                  color: Colors.black54,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const Signup()),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.translate("SIGN UP") ??
                                    "SIGN UP",
                                style: const TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  color: GlobalVariables.primaryColor,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
