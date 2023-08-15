import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final EdgeInsets padding;
  final BoxDecoration decoration;
  final Alignment alignment;
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.padding = const EdgeInsets.all(30.0),
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: padding,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(178, 142, 22, 1),
            textStyle: const TextStyle(fontSize: 20.0),
            padding: const EdgeInsets.all(20.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          child: Align(
            alignment: alignment,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                color: Colors.black,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
