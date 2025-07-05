import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/feedview.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return _buildPageView(context);
  }

  Widget _buildPageView(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildMainPage(context),
        const FeedView(),
      ],
    );
  }

  Widget _buildMainPage(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFFFFFFFF),
      body: _buildMainBody(context),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 75,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAE3),
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
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
            color: Colors.black,
            width: 0.4,
            ),
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

  Widget _buildMainBody(BuildContext context) {
  return Column(
    children: [
      Spacer(flex: 2),
      Expanded(
        flex: 5,
        child: _buildBookStack(context),
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


Widget _buildBookStack(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth * 0.85, // 화면 너비의 80%
    decoration: BoxDecoration(
      color: const Color(0xFFF7F2AF),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 4),
        )
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/RecommendImageButton.png',
                fit: BoxFit.cover,
                width: 350,
                height: 350,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text(
          '마음이 따뜻해지는 한 권을 만나보세요.',
          style: GoogleFonts.nanumPenScript(
            fontSize: 28,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}




  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '유저들이 읽은 책들을\n찾아보세요!',
            style: GoogleFonts.nanumPenScript(
              fontSize: 22,
              // ignore: deprecated_member_use
              color: const Color(0xFF000000).withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.keyboard_double_arrow_down,
            size: 32,
            // ignore: deprecated_member_use
            color: const Color(0xFF000000).withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
