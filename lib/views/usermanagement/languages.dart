import 'package:cargo/Components/Home_Page.dart';
import 'package:cargo/localization/app_localizations.dart';
import 'package:cargo/views/Bottom_Navigation.dart';
import 'package:cargo/views/usermanagement/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_bloc.dart';
import '../../localization/localization_event.dart';
import '../../model/Language.dart';

class LanguageListItem extends StatelessWidget {
  LanguageListItem();
  List<Language> languages = [
    Language(
      languageCode: 'en',
      languageName: 'English',
      locale: Locale('en', ''),
    ),
    Language(
      languageCode: 'am',
      languageName: 'Amharic',
      locale: Locale('am', ''),
    ),
  ];

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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
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
                AppLocalizations.of(context)?.translate("Language") ??
                    "Language",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          height: screenHeight * 0.4,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(languages[index].languageName),
                    onTap: () {
                      context
                          .read<LocaleBloc>()
                          .add(ChangeLocale(languages[index].locale));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ));
  }
}
