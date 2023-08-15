import 'dart:convert';
import 'dart:io';
import 'package:cargo/views/usermanagement/Profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cargo/shared/constant.dart';
import 'package:cargo/views/usermanagement/login.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../constant/global_variables.dart';
import '../../localization/app_localizations.dart';
import '../../services/api_service.dart';
import '../../shared/custom-form.dart';
import '../../shared/customButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  String? companyName;
  String? ownerAvatar;
  String? phoneNumber;
  String? businessName;
  String? businessSector;
  String? businessType;
  String? region;
  String? subcity;
  String? specificLocation;
  ProfileEdit(
      {super.key,
      this.companyName,
      required this.ownerAvatar,
      required this.phoneNumber,
      required this.businessName,
      required this.businessSector,
      required this.businessType,
      required this.region,
      required this.subcity,
      required this.specificLocation});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

TextEditingController from = TextEditingController();

class _ProfileEditState extends State<ProfileEdit> {
  final _companyController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PickedFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  String? owneriamg;
  AuthService auth = AuthService();

  void takePicture(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);

    setState(() {
      owneriamg = File(image!.path).path;
    });
  }

  updateProfile(String? pro) {
    auth.updateProfile(pro);
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed

    _genderController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  bool _isErrorVisible = false;
  bool _isFocus = false;
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
              child: const Center(
                child: Text(
                  "Update Profile Here",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.15,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 58,
                                backgroundColor: Colors.white,
                                backgroundImage: _pickedImage == null
                                    ? NetworkImage("${widget.ownerAvatar}")
                                    : FileImage(File(_pickedImage!.path))
                                        as ImageProvider,
                              ),
                            ),
                            Positioned(
                              left: 62,
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.07),
                                child: RawMaterialButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Choose Option',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  GlobalVariables.primaryColor,
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    takePicture(
                                                        ImageSource.camera);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons.camera,
                                                          color: GlobalVariables
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    takePicture(
                                                        ImageSource.gallery);
                                                  },
                                                  splashColor: GlobalVariables
                                                      .primaryColor,
                                                  child: Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons.browse_gallery,
                                                          color: GlobalVariables
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  elevation: 10,
                                  fillColor: GlobalVariables.primaryColor,
                                  child: Icon(Icons.add_a_photo),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(AppLocalizations.of(context)
                              ?.translate("Company Name") ??
                          "Company Name")),
                  TextFormField(
                    controller: _companyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: '${widget.companyName}',
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
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.companyName}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your company name') ??
                            "Please enter your company name";
                      }
                      return null;
                    },
                    // validator: _validateDate,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(AppLocalizations.of(context)
                            ?.translate("Mobile Number") ??
                        "Mobile Number"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.phoneNumber}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.phoneNumber}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(AppLocalizations.of(context)
                            ?.translate("Business Name") ??
                        "Business Name"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.businessName}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.businessName}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(AppLocalizations.of(context)
                            ?.translate("Business Sector") ??
                        "Business Sector"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.businessSector}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.businessSector}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(AppLocalizations.of(context)
                            ?.translate("Business Type") ??
                        "Business Type"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.businessType}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.businessType}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                        AppLocalizations.of(context)?.translate("Region") ??
                            "Region"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.region}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.region}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                        AppLocalizations.of(context)?.translate("Sub City") ??
                            "Sub City"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.subcity}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.subcity}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(AppLocalizations.of(context)
                            ?.translate("Specific Location") ??
                        "Specific Location"),
                  ),
                  CustomTextFieldForm(
                    readOnly: true,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    hintText: "${widget.specificLocation}",
                    textController: _emailController,
                    obscureText: false,
                    hintTextStyle: TextStyle(
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      color: _isFocus ? Colors.red : Colors.grey,
                      // ... other styles
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if ("${widget.specificLocation}" == null) {
                        return AppLocalizations.of(context)
                                ?.translate('Please enter your email ') ??
                            "Please enter your email ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    onPressed: () {
                      updateProfile(owneriamg);
                    },
                    text: AppLocalizations.of(context)?.translate('Update') ??
                        "Update",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
