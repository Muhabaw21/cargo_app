import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class NetWorkError extends StatelessWidget {
  const NetWorkError({super.key});
  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
        child: FutureBuilder(
      future: Future.delayed(
          const Duration(seconds: 40), () => _checkInternetConnection()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        } else {
          return Container(
              alignment: Alignment.center,
              height: screenHeight * 0.13,
              width: screenWidth * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200.withOpacity(0.7),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: const Offset(
                        6, // Move to right 7.0 horizontally
                        8, // Move to bottom 8.0 Vertically
                      ))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text('Network Error',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'No Network. Connect your device to internet or mobile data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ));
        }
      },
    ));
  }
}
