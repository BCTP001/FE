import 'fluid-nav-bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'content/home.dart';
import 'content/search.dart';
import 'content/collection.dart';

void main() => runApp(FluidNavBarDemo());

class FluidNavBarDemo extends StatefulWidget {
  @override
  State createState() {
    return _FluidNavBarDemoState();
  }
}

class _FluidNavBarDemoState extends State {
  Widget? _child;

  @override
  void initState() {
    super.initState();
    _child = HomeContent();
  }

  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF7EEDC3),
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                icon: Icons.home,
                backgroundColor: Color(0xFFD0C38F),
                extras: {"label": "home"}),
            FluidNavBarIcon(
                icon: Icons.search,
                backgroundColor: Color(0xFFD0C38F),
                extras: {"label": "bookmark"}),
            FluidNavBarIcon(
                icon: Icons.collections_bookmark,
                backgroundColor: Color(0xFFD0C38F),
                extras: {"label": "partner"}),
            FluidNavBarIcon(
                // svgPath: "assets/conference.svg",
                icon: Icons.settings,
                backgroundColor: Color(0xFFD0C38F),
                extras: {"label": "conference"}),
          ],
          onChange: _handleNavigationChange,
          style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.white,
            barBackgroundColor: Color(0xFFE8DCC4),
          ),
          scaleFactor: 1.5,
          defaultIndex: 0,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras!["label"],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = HomeContent();
          break;
        case 1:
          _child = SearchContent();
          break;
        case 2:
          _child = CollectionContent();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 100),
        child: _child,
      );
    });
  }
}
