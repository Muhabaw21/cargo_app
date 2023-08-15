import 'package:cargo/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import '../Components/Communicate.dart';
import 'usermanagement/Profile.dart';
import '../Components/Tracking.dart';
import '../Components/Home_Page.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final backgroundColor = Color.fromRGBO(178, 142, 22, 1);
    return WillPopScope(
      onWillPop: () async {
        if (_tabController!.index > 0) {
          _tabController!.animateTo(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          controller: _tabController,
          children: [
            CargoOWnerHomePage(),
            const Tracking(),
            const Communicate(),
            Profile(),
          ],
        ),
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          decoration: BoxDecoration(color: backgroundColor),
          child: SizedBox(
            width: screenWidth,
            child: Center(
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                indicatorColor: Colors.black,
                isScrollable: true,
                indicatorWeight: 3,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tabs: [
                  Tab(
                    icon: const Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.translate("Home") ?? "Home",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Tab(
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.translate("Tracking") ??
                            "Tracking",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      Icons.messenger,
                      color: Colors.black,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.translate("Message") ??
                          "Message",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.translate("Profile") ??
                          "Profile",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
