import 'package:flutter/material.dart';

showAlertDialogSuccuss(BuildContext context) {
  // set up the button
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromARGB(255, 13, 199, 44)),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(color: Colors.grey, width: 3),
    ),
    backgroundColor: Colors.white,
    title: const Center(
      child: Text(
        "Succuss !!!",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
      ),
    ),
    content: const Text(
      "Successfully Register !!!",
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
