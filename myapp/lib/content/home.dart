import 'package:flutter/material.dart';
import '../placeholder/placeholder_card_tall.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EEDC3),
        title: Text('전투모의지원중대'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Book Illustration
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '📚', // You can use any custom image or icon
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Korean Text
              Text(
                '오늘의 책을 추천해드립니다',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              // Footer Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    '유저들이 읽은 책들을\n찾아보세요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Down Arrow Icon
              Icon(
                Icons.arrow_downward,
                size: 30,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
