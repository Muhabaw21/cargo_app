import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 168, 123, 7)),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "Error",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
    ),
    content: const Text(
      "Invalid User Name Or Passowrd",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    ),
    actions: [
      okButton,
    ],
  );


  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
