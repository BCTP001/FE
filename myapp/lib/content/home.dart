import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/feedview.dart';
import 'dart:ui';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _createScrollBehavior(),
      home: _buildPageView(),
    );
  }

  ScrollBehavior _createScrollBehavior() {
    return MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      },
    );
  }

  Widget _buildPageView() {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      children: [
        _buildMainPage(),
        const FeedView(),
      ],
    );
  }

  Widget _buildMainPage() {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF7EEDC3),
      body: _buildMainBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF7EEDC3),
      title: Builder(
        builder: (context) => _buildAppBarTitle(context),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8DCC4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '전투모의지원중대',
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMainBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _buildBookStack(),
          ),
        ),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildBookStack() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/book.png',
          fit: BoxFit.contain,
          width: 225,
          height: 284,
        ),
        Positioned(
          child: Text(
            '오늘의 책을 \n 추천해드립니다',
            style: GoogleFonts.nanumBrushScript(
              fontSize: 40,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '유저들이 읽은 책들을\n찾아보세요!',
            style: GoogleFonts.nanumBrushScript(
              fontSize: 20,
              color: const Color(0xFF5F6368),
            ),
            textAlign: TextAlign.center,
          ),
          const Icon(
            Icons.keyboard_double_arrow_down,
            size: 32,
            color: Color(0xFF5F6368),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
