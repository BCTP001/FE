import 'package:flutter/material.dart';
import 'dart:math';
import 'feed.dart';

// 랜덤 색상 구하는 함수
Color getRandomColorWithBrightness(double minLightness, double maxLightness) {
  final random = Random();

  // 랜덤한 색상(Hue: 0~360), 채도(Saturation: 0.5~1), 밝기(Lightness: 설정 범위 내)
  final hslColor = HSLColor.fromAHSL(
    1.0, // Alpha (불투명도)
    random.nextDouble() * 360, // Hue (색상)
    0.8, // Saturation (채도, 0~1)
    minLightness + random.nextDouble() * (maxLightness - minLightness), // Lightness (밝기)
  );

  return hslColor.toColor();
}

class Feedbook {
  final String review, cover, title;
  final int likes, added;
  final Color color;
  const Feedbook(this.review, this.cover, this.title,  this.likes, this.added, this.color);
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  int currentPage = 0;
  List<Feedbook> books = [Feedbook("2025 최고의 책.", "https://image.aladin.co.kr/product/31893/32/cover500/k212833749_2.jpg", "아몬드", 9, 7,  getRandomColorWithBrightness(0.3, 0.6)),
                             Feedbook("꿀꿀.", "https://image.aladin.co.kr/product/4/6/cover500/s93746005x_3.jpg", "동물농장", 10, 8,  getRandomColorWithBrightness(0.3, 0.6)),
                             Feedbook("무섭다", "https://image.aladin.co.kr/product/41/89/cover500/s122531356_2.jpg", "1984", 9, 7,  getRandomColorWithBrightness(0.3, 0.6))];
  

  final PageController controller =
  PageController(initialPage: 0, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: controller,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Feed(books[index].review, books[index].cover, books[index].title, books[index].likes, books[index].added, books[index].color);
      },
    );
  }
}