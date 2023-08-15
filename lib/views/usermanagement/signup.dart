import 'package:cargo/shared/constant.dart';
import 'package:cargo/views/usermanagement/login.dart';
import 'package:flutter/material.dart';
import '../../constant/global_variables.dart';
import '../../localization/app_localizations.dart';
import '../../services/api_service.dart';
import '../../shared/custom-form.dart';
import '../../shared/customButton.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

TextEditingController from = TextEditingController();

class _SignupState extends State<Signup> {
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  void signUpUser() async {
    if (_signUpFormKey.currentState!.validate()) {
      _signUpFormKey.currentState!.save();
      final companyName = _companyController.text;
      final phone = _phoneController.text;
      final password = _passwordController.text;
      final confirm = _confirmPasswordController.text;
      await authService.signUpUser(
        context: context,
        companyName: companyName,
        phone: phone,
        password: password,
        confirmPassword: confirm,
      );
    }
  }

  bool _isErrorVisible = false;
  final bool _isFocus = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 80,
                margin: const EdgeInsets.only(top: 40, left: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Cargo_login()),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.3),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: GlobalVariables.primaryColor,
                            fontFamily: "Roboto",
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: screenHeight - 30,
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.only(top: 50),
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextFieldForm(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: "Roboto"),
                          hintText: AppLocalizations.of(context)
                                  ?.translate("Company Name") ??
                              "Company Name",
                          textController: _companyController,
                          keyboardType: TextInputType.text,
                          hintTextStyle: TextStyle(
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                            color: _isFocus ? Colors.red : Colors.grey,
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)?.translate(
                                      "Please enter your company name") ??
                                  "Please enter your company name";
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextFieldForm(
                          keyboardType: TextInputType.phone,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                          hintText: AppLocalizations.of(context)
                                  ?.translate("Phone Number") ??
                              "Phone Number",
                          textController: _phoneController,
                          obscureText: false,
                          hintTextStyle: TextStyle(
                            letterSpacing: 1.0,
                            wordSpacing: 2.0,
                            color: _isFocus ? Colors.red : Colors.grey,
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)?.translate(
                                      'Please enter your phone number') ??
                                  "Please enter your phone number ";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFieldForm(
                              hintText: AppLocalizations.of(context)
                                      ?.translate('Password') ??
                                  "Password",
                              textController: _passwordController,
                              isPassword: true,
                              hintTextStyle: TextStyle(
                                letterSpacing: 1.0,
                                wordSpacing: 2.0,
                                color:
                                    _isErrorVisible ? Colors.red : Colors.grey,
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                              onChanged: (value) {
                                if (_isErrorVisible) {
                                  setState(() {
                                    _isErrorVisible = false;
                                  });
                                }
                              },
                              obscureText: true,
                              showSuffixIcon: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)
                                          ?.translate(
                                              'Please Enter Password') ??
                                      "Please Enter Password";
                                }
                                final passwordRegex =
                                    RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$');
                                if (!passwordRegex.hasMatch(value)) {
                                  setState(() {
                                    _isErrorVisible = true;
                                  });
                                  return " ";
                                }
                                return PasswordMatchValidator.validate(
                                    value, _confirmPasswordController.text);
                              },
                            ),
                            if (_isErrorVisible) // Only show the error message if it's visible
                              const Text(
                                "Password must contain at least one capital letter, one number, and be at least 8 characters long",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextFieldForm(
                            hintText: AppLocalizations.of(context)
                                    ?.translate('Confirm Password') ??
                                "Confirm Password",
                            textController: _confirmPasswordController,
                            isPassword: true,
                            textStyle: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold),
                            onChanged: (value) {
                              print("password changed: $value");
                            },
                            obscureText: true,
                            hintTextStyle: TextStyle(
                              letterSpacing: 1.0,
                              wordSpacing: 2.0,
                              color: _isFocus ? Colors.red : Colors.grey,
                            ),
                            showSuffixIcon: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Confirm Password";
                              }
                              return PasswordMatchValidator.validate(
                                  _passwordController.text, value);
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          onPressed: signUpUser,
                          text: AppLocalizations.of(context)
                                  ?.translate('SIGN UP') ??
                              "SIGN UP",
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 20),
                                  child: Text(
                                    AppLocalizations.of(context)?.translate(
                                            "Already have an account?") ??
                                        "Already have an account?",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      color: Colors.black54,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Cargo_login()),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                            ?.translate("LOGIN") ??
                                        "LOGIN",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: GlobalVariables.primaryColor,
                                      letterSpacing: 1.0,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
