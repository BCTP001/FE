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
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        home: PageView(
            scrollDirection: Axis.vertical,
            controller: pageController,
            children: [
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF7EEDC3),
                  title: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8DCC4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '전투모의지원중대',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  centerTitle: true,
                ),
                backgroundColor: Color(0xFF7EEDC3),
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Stack(
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
                            )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '유저들이 읽은 책들을\n찾아보세요!',
                            style: GoogleFonts.nanumBrushScript(
                              fontSize: 20,
                              color: Color(0xFF5F6368),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.keyboard_double_arrow_down,
                            size: 32,
                            color: Color(0xFF5F6368),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const FeedView(),
            ]));
  }
}
