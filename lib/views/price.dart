import 'package:cargo/shared/customAppbar.dart';
import 'package:flutter/material.dart';


class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Price"),
      body: const Column(children: [
        Text("Trust The Process"),
      ]),
    );
  }
}