import 'package:flutter/material.dart';

import 'constant.dart';

class TabNavigate extends StatefulWidget {
  const TabNavigate({super.key});

  @override
  State createState() => _TabNavigateState();
}

class _TabNavigateState extends State with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5),
          labelStyle: TextStyle(
              letterSpacing: 2.0,
              wordSpacing: 1,
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold),
          indicatorColor: kPrimaryColor,
          isScrollable: false,
          indicatorWeight: 4,
          labelColor: Color.fromARGB(255, 150, 217, 242),
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: Icon(Icons.history),
              text: "Cargo History",
            ),
            Tab(
              icon: Icon(Icons.add),
              text: "Post Cargo",
            ),
          ],
        ),
        title: const Text("Today's cargo Price"),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            child: child,
            position: Tween(
              begin: Offset(0, animation.value),
              end: Offset.zero,
            ).animate(animation),
          );
        },
        child: TabBarView(
          key: ValueKey(_tabController?.index),
          controller: _tabController,
          children: [
            //  CargoListView(),
            //Posts(),
          ],
        ),
      ),
    );
  }
}
