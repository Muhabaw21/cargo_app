import 'package:cargo/Components/Home_Page.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:cargo/views/usermanagement/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../localization/app_localizations.dart';
import '../views/Post/Post_Navigation.dart';
import 'navigateBloc.dart';
import 'navigatestateEvent.dart';

class MainApp extends StatelessWidget {
  final Locale locale;
  final String routeName;
  final Map<String, WidgetBuilder> routeBuilders = {
    '/login': (BuildContext context) => Cargo_login(),
    '/bottomNav': (BuildContext context) =>
        Builder(builder: (context) => BottomNav()),
    '/home': (BuildContext context) => CargoOWnerHomePage(),
    // Add more pages here
  };

  MainApp({required this.locale, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return routeBuilders[routeName]!(context);
  }
}
