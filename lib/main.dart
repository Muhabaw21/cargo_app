
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Components/Home_Page.dart';
import 'localization/app_localizations.dart';
import 'localization/localization_bloc.dart';
import 'localization/localization_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'navigate/mainNavigation.dart';
import 'navigate/navigateBloc.dart';
import 'navigate/navigatestateEvent.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) {
      return ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: child!,
      );
    },
    home: MyApp(),
  ));
}

configLoading() {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, navigationState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates:const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                 Locale('en', ''),
                 Locale('am', ''),
                ],
                locale: localeState.locale,
                home: MainApp(
                  locale: localeState.locale,
                  routeName: navigationState.routeName,
                ),
                routes: {
                  '/bottomNav': (BuildContext context) => BottomNav(),
                  '/home': (BuildContext context) => CargoOWnerHomePage(),
                  // Add more pages here
                },
              );
            },
          );
        },
      ),
    );
  }
}
