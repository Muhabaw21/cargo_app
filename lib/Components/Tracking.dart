import 'package:cargo/localization/app_localizations.dart';
import 'package:cargo/shared/customAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../views/Bottom_Navigation.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNav()));
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
                AppLocalizations.of(context)?.translate("Tracking Page") ??
                    "Tracking Page",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          child: Center(
            child: Text(
                AppLocalizations.of(context)?.translate("Trust The Process") ??
                    "Trust The Process"),
          ),
        ));
  }
}
