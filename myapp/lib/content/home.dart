import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/feedview.dart';
import 'dart:ui';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return _buildPageView();
  }

  Widget _buildPageView() {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildMainPage(),
        const FeedView(),
      ],
    );
  }

  Widget _buildMainPage() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF9AD9B8),
      body: _buildMainBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 75,
      elevation: 0, 
      backgroundColor: Colors.transparent, 
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9AD9B8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      title: Builder(
        builder: (context) => Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE5D8BE),
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
        ),
      ),
      centerTitle: true,
    );
  }


  Widget _buildAppBarTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE5D8BE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '전투모의지원중대',
        style: GoogleFonts.inter(
          fontSize: 18,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

Widget _buildMainBody() {
  return Column(
    children: [
      Spacer(flex: 2),
      Expanded(
        flex: 5,
        child: _buildBookStack(),
      ),
      Expanded(
        flex: 3, 
        child: Center(
          child: _buildBottomSection(),
        ),
      ),
    ],
  );
}

Widget _buildBookStack() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/book.png',
            fit: BoxFit.contain,
            width: 250,
            height: 320,
          ),
          Positioned(
            top: 20,
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
      ),
      const SizedBox(height: 12),
      Text(
        '마음이 따뜻해지는 한 권을 만나보세요.',
        style: GoogleFonts.nanumBrushScript(
          fontSize: 20,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '유저들이 읽은 책들을\n찾아보세요!',
            style: GoogleFonts.nanumBrushScript(
              fontSize: 20,
              color: const Color(0xFF5F6368).withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.keyboard_double_arrow_down,
            size: 32,
            color: const Color(0xFF5F6368).withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
