import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme _appThemeInstance = AppTheme();
  factory AppTheme() {
    return _appThemeInstance;
  }
  //Colors
  Color get primaryColor => Color(0xFF035AA6);
  Color get backgroundColor => Color(0xFFF1EFF1);
  Color get secondaryColor => Color(0xFF03DAC5);
  Color get textColor => Color(0xFFFFFFFF);
  Color kTextLightColor = Color(0xFF747474);
  //Fonts
  String get mainFontFamily => 'Roboto';
  //padding
  EdgeInsets get mainPadding =>
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  //Text Styles
  TextStyle primaryText(double fontSize) {
    return TextStyle(
      color: textColor,
      fontFamily: mainFontFamily,
      fontSize: fontSize,
    );
  }

  //Decorations
  BoxDecoration get mainBoxDecoration => BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 25,
              spreadRadius: 1,
            ),
          ]);
}
