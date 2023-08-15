import 'package:cargo/views/Post/histrory.dart';
import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';
import 'Posts.dart';

class Post_BottomNav extends StatefulWidget {
  Post_BottomNav({super.key});

  @override
  _Post_BottomNavState createState() => _Post_BottomNavState();
}

class _Post_BottomNavState extends State<Post_BottomNav>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    const backgroundColor = Color.fromRGBO(178, 142, 22, 1);
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
            const Posts(),
            CargoHistory(),
          ],
        ),
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          decoration: const BoxDecoration(color: backgroundColor),
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
                        Icons.add,
                        color: Colors.black,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.translate("Post Cargo") ??
                            "Post Cargo",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.history_edu,
                        color: Colors.black,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                                ?.translate("Cargo History") ??
                            "Cargo History",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
