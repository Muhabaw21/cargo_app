import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cargo/shared/constant.dart';
import 'package:flutter/material.dart';
import '../../constant/global_variables.dart';
import '../../localization/app_localizations.dart';
import '../../shared/custom-form.dart';
import '../../shared/customButton.dart';
import '../../shared/storage_hepler.dart';
import 'Profile.dart';
import 'login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

TextEditingController from = TextEditingController();

class _ChangePasswordState extends State<ChangePassword> {
  final _currentPassController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  changePassword(String currentPass, String newPass, String confirmPass) async {
    const url = 'http://164.90.174.113:9090/Api/User/ChangePassword';

    // Define your request data as a Map
    Map requestData = {
      'currentPin': "${currentPass}",
      'newPin': "${newPass}",
      'confirmNewPin': "${confirmPass}",
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
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        final response = await http.post(
          Uri.parse(url),
          body: body,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken",
          },
        );
        print(response.body);
        print(response.statusCode);
        final Map jsonResponse = json.decode(response.body);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Cargo_login()),
          );
        } else {
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  bool _isFocus = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
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
                AppLocalizations.of(context)
                        ?.translate("Password change page") ??
                    "Password change page",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 45),
                    child: const CircleAvatar(
                      backgroundColor: GlobalVariables.primaryColor,
                      radius: 60,
                      child: Icon(Icons.lock, color: Colors.black, size: 70),
                    ),
                  ),
                  CustomTextFieldForm(
                    hintText: AppLocalizations.of(context)
                            ?.translate('Current Password') ??
                        "Current Password",
                    textController: _currentPassController,
                    isPassword: true,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                    ),
                    textStyle: TextStyle(fontSize: 16),
                    onChanged: (value) {
                      print("password changed: $value");
                    },
                    obscureText: true,
                    showSuffixIcon: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter Current password') ??
                            "Please enter Current password";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFieldForm(
                    hintText: AppLocalizations.of(context)
                            ?.translate('New Password') ??
                        "New Password",
                    textController: _newPasswordController,
                    isPassword: true,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    textStyle:const TextStyle(fontSize: 16),
                    onChanged: (value) {
                      print("password changed: $value");
                    },
                    obscureText: true,
                    showSuffixIcon: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter new password') ??
                            "Please enter new password";
                      }
                      return PasswordMatchValidator.validate(
                          value, _newPasswordController.text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFieldForm(
                    hintText: AppLocalizations.of(context)
                            ?.translate('Confirm Password') ??
                        "Confirm Password",
                    textController: _confirmPassController,
                    isPassword: true,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    textStyle: TextStyle(fontSize: 16),
                    onChanged: (value) {
                      print("password changed: $value");
                    },
                    obscureText: true,
                    showSuffixIcon: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.translate('Please Confirm Password') ??
                            "Please Confirm Password";
                      }
                      return PasswordMatchValidator.validate(
                          value, _newPasswordController.text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    onPressed: () async {
                      await changePassword(
                        _currentPassController.text,
                        _newPasswordController.text,
                        _confirmPassController.text,
                      );
                    },
                    text: AppLocalizations.of(context)
                            ?.translate('Change Password') ??
                        "Change Password",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class PasswordMatchValidator {
  static String? validate(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return "password do not match";
    }
    return null;
  }
}
