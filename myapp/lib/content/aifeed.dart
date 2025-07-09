import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/graphql_client.dart';
import '../component/util.dart';

class BookRecommendationContent extends StatefulWidget {
  const BookRecommendationContent({super.key});

  @override
  State<BookRecommendationContent> createState() =>
      _BookRecommendationContentState();
}

class _BookRecommendationContentState extends State<BookRecommendationContent>
    with SingleTickerProviderStateMixin {
  String selectedKeyword = '';
  final List<String> keywords = [
    "로맨스",
    "힐링",
    "자기계발",
    "과학",
    "주식",
    "코딩",
    "판타지",
    "만화",
    "정치",
    "사회",
    "요리",
    "문학",
    "성장",
    "청소년",
    "세계",
    "미군"
  ];

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> recommendedBooks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '오늘의 책',
            style: GoogleFonts.nanumBrushScript(
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black45,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '키워드'),
              Tab(text: '도서'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildKeywordTab(),
            buildBookSearchTab(),
          ],
        ),
      ),
    );
  }

  Widget buildKeywordTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("키워드로 추천 받기",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: keywords.map((keyword) {
              final isSelected = selectedKeyword == keyword;
              return ChoiceChip(
                label: Text(keyword),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedKeyword = isSelected ? '' : keyword;
                  });
                },
                selectedColor: AppColors.primaryBrown,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: selectedKeyword.isEmpty
                  ? null
                  : () => fetchRecommendations(selectedKeyword),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("책 추천 받기",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget buildBookSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("도서 검색",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "검색어를 입력하세요",
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: _searchController.text.trim().isEmpty
                  ? null
                  : () => fetchRecommendations(_searchController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("책 추천 받기",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> fetchRecommendations(String keyword) async {
    setState(() {
      isLoading = true;
    });

    try {
      final books = await GraphQLService.recommendBooks(keyword, 5);
      setState(() {
        recommendedBooks = books;
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                RecommendationResultScreen(books: recommendedBooks)),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('추천 실패: $e');
    }
  }
}

class RecommendationResultScreen extends StatelessWidget {
  final List<dynamic> books;
  const RecommendationResultScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      appBar: CommonWidgets.buildAppBar(
        onBackPressed: () => Navigator.pop(context),
      ),
      body: books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "추천 결과가 없습니다.",
                    style: GoogleFonts.jua(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simple header
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "키워드를 바탕으로\n",
                          style: GoogleFonts.nanumBrushScript(
                            fontSize: 32,
                            color: Colors.white, // Base color
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "5권의 도서", // Specific text part
                              style: GoogleFonts.nanumBrushScript(
                                fontSize: 32,
                                color: AppColors
                                    .darkGreen, // Different color for this part
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "를 찾아보았어요", // Remaining text part
                              style: GoogleFonts.nanumBrushScript(
                                fontSize: 32,
                                color: Colors.white, // Back to base color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return _buildBookCard(context, book);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBookCard(BuildContext context, dynamic book) {
    return Card(
      color: AppColors.lightCream,
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Book cover section
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: buildBookCover(book['author'], 250, 355),
              ),
            ),

            const SizedBox(height: 20),
            // Description section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 22,
                        color: AppColors.darkGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "도서 소개",
                        style: GoogleFonts.jua(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['title'] ?? '제목 없음',
                    style: GoogleFonts.jua(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['description'] ?? '설명이 없습니다.',
                    style: GoogleFonts.jua(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Author/Publisher info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.darkGreen,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      book['cover'] ?? '정보 없음',
                      style: GoogleFonts.jua(
                        fontSize: 13,
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Simple action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action when button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "자세히 보기",
                  style: GoogleFonts.jua(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
