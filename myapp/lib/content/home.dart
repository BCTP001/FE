import 'package:fluid_nav_bar/component/feedview.dart';
import 'package:flutter/material.dart';
import '../placeholder/placeholder_card_tall.dart';

import '../component/feed.dart';
import 'dart:ui';

class HomeContent extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),

      home: FeedView(),
    );
  }
}
