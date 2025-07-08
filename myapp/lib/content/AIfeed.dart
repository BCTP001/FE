import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../component/graphql_client.dart';

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
    "로맨스", "힐링", "자기계발", "과학", "주식", "코딩", "판타지",
    "만화", "정치", "사회", "요리", "문학", "성장", "청소년", "세계", "미군"
  ];

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> recommendedBooks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

  // 검색창 입력이 바뀔 때마다 setState() 호출해서 버튼 상태 업데이트
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFB7FFE3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFB7FFE3),
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
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFFFDFCE5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.home, size: 28),
                Icon(Icons.search, size: 28),
                Icon(Icons.bookmark, size: 28),
                Icon(Icons.settings, size: 28),
              ],
            ),
          ),
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
                selectedColor: const Color(0xFF5D3A00),
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
              onPressed: selectedKeyword.isEmpty ? null : () => fetchRecommendations(selectedKeyword),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D3A00),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("책 추천 받기",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
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
          const Text("도서 검색", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "검색어를 입력하세요",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: _searchController.text.trim().isEmpty
                  ? null
                  : () => fetchRecommendations(_searchController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D3A00),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("책 추천 받기",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchRecommendations(String keyword) async {
    setState(() {
      isLoading = true;
    });
    
    final ValueNotifier<GraphQLClient> client = GraphQLService.getClient();

    try {
      final books = await GraphQLService.recommendBooks(keyword, 5);
      setState(() {
        recommendedBooks = books;
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecommendationResultScreen(books: recommendedBooks)),
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
      backgroundColor: const Color(0xFF9AD9B8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9AD9B8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: books.isEmpty
          ? const Center(child: Text("추천 결과가 없습니다."))
          : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(
                        "키워드를 바탕으로\n도서를 찾아보았어요",
                        style: GoogleFonts.nanumBrushScript(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      color: Color(0xFFF5F5DC),
      margin: const EdgeInsets.symmetric(vertical: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildBookCover(book['author']),
            const SizedBox(height: 12),
            Text(
              book['title'] ?? '제목 없음',
              style: GoogleFonts.jua(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
            ),
            const SizedBox(height: 6),
            Text(
              book['description'],
              style: GoogleFonts.jua(
                        fontSize: 16,
                      ),
            ),
            Text(
              book['cover'],
              style: GoogleFonts.jua(
                        fontSize: 16,
                        color: Color(0xFF037549),
                      ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildBookCover(String? coverUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: coverUrl != null
          ? Image.network(
              coverUrl,
              width: 200,
              height: 280,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.book, size: 100);
              },
            )
          : const Icon(Icons.book, size: 100),
    );
  }
}
