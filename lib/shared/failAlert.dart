import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
void _showSweetAlert(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.info,
    title: "Sweet Alert",
    desc: "This is an example of a sweet alert in Flutter.",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

// Usage:
