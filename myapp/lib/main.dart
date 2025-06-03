import 'fluid-nav-bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'content/home.dart';
import 'content/search.dart';
import 'content/bookmark.dart';
import 'content/login.dart';

void main() => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookmarksProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFABF4D0),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoggedIn ? MainApp() : WelcomeScreen();
        },
      ),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/setup1': (context) => SetupScreen1(),
        //'/setup2': (context) => SetupScreen2(),
        //'/setup3': (context) => SetupScreen3(),
        //'/setup4': (context) => SetupScreen4(),
        //'/setup5': (context) => SetupScreen5(),
        //'/main': (context) => MainApp(),
      },
    );
  }
}


// Your original MainApp with fluid navigation bar
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() {
    return _MainApp();
  }
}

class _MainApp extends State<MainApp> {
  Widget? _child;

  @override
  void initState() {
    super.initState();
    _child = HomeContent();
  }

  @override
  Widget build(context) {
    return Scaffold(
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
              extras: {"label": "search"}),
          FluidNavBarIcon(
              icon: Icons.collections_bookmark,
              backgroundColor: Color(0xFFD0C38F),
              extras: {"label": "bookmark"}),
          FluidNavBarIcon(
              icon: Icons.settings,
              backgroundColor: Color(0xFFD0C38F),
              extras: {"label": "settings"}),
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
          _child = BookmarkContent();
          break;
        // case 3:
        //   _child = SettingsContent();
        //   break;
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