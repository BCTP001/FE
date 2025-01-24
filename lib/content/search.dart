import 'package:flutter/material.dart';

// lib/search/search.dart


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> allItems = ['아몬드', '아몬드', '아몬드', '아몬드', '아몬드'];
  List<String> filteredItems = [];
  List<String> imageUrls = [
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
    'https://image.aladin.co.kr/product/35515/85/cover500/k342036760_1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
    _searchController.addListener(_filterItems);
  }

  // 검색어에 맞춰 리스트 필터링
  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('어떤 책을 찾으시나요?'),
        centerTitle: true,
        backgroundColor: Color(0xFF98FBCB),
      ),
      backgroundColor: Color(0xFF80471C),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // 검색창
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: '검색',
                labelStyle: TextStyle(color: Colors.black),
                hintText: '검색어를 입력하세요',
                suffixIcon: Icon(Icons.search,color: Colors.black,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    width: 2.0
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            GridView.builder(
                shrinkWrap: true, // 스크롤 뷰 안에서 동작하도록 설정
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 열의 개수
                  crossAxisSpacing: 8.0, // 열 간격
                  mainAxisSpacing: 8.0, // 행 간격
                  childAspectRatio: 1.0, // 이미지의 비율 (정사각형)
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // 이미지 둥근 테두리
                    child: Image.network(
                      imageUrls[index],
                      //fit: BoxFit.cover, // 이미지가 박스에 맞게 채워짐
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    )
   );
  }
}

