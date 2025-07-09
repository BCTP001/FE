import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/util.dart';

class BookDetailsScreen extends StatefulWidget {
  final dynamic book;
  final bool isInitiallyBookmarked;
  final Function(String) onBookmarkToggle;

  const BookDetailsScreen({
    super.key,
    required this.book,
    this.isInitiallyBookmarked = false,
    required this.onBookmarkToggle,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final Map<String, bool> _expandedSections = {
    "도서정보": true,
    "목차": false,
    "책소개": false,
  };
  late bool isBookmarked;
  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isInitiallyBookmarked;
  }

  void _toggleSection(String title) {
    setState(() {
      _expandedSections[title] = !_expandedSections[title]!;
    });
  }

  String cleanText(String text) {
    return text
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.primaryGreen,
      body: SingleChildScrollView(
        // ScrollView for the entire body
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 책 표지
              buildBookCover(widget.book['cover'], 250, 355),
              const SizedBox(height: AppDimensions.mediumSpacing),
              // 제목
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Pushes items to the edges
                children: [
                  Expanded(
                    child: Text(
                      widget.book['title'] ?? '',
                      style: AppStyles.titleStyle.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_added : Icons.bookmark_add,
                      size: 40,
                      color: isBookmarked ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      widget.onBookmarkToggle(widget.book['isbn']);
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              // 저자
              Text(
                widget.book['author'] ?? '',
                style: AppStyles.bodyStyle
                    .copyWith(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: AppDimensions.smallSpacing),
              Text(
                '현재 0명의 유저들이 이 책을 읽고 있습니다!',
                style: AppStyles.bodyStyle
                    .copyWith(fontSize: 15, color: AppColors.darkGreen),
              ),
              const SizedBox(height: AppDimensions.smallSpacing + 2),
              Container(
                padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
                child: buildCategoryTags(widget.book['categoryName']),
              ),
              const SizedBox(height: AppDimensions.mediumSpacing),
              // 도서정보
              _buildInfoBox("도서정보", [
                Text(
                  "발행일: ${widget.book['pubDate'] ?? ''}",
                  style: AppStyles.bodyStyle
                      .copyWith(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "${widget.book['bookinfo']['itemPage'] ?? ''}쪽",
                  style: AppStyles.bodyStyle
                      .copyWith(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "ISBN: ${widget.book['isbn'] ?? ''}",
                  style: AppStyles.bodyStyle
                      .copyWith(fontSize: 16, color: Colors.black),
                ),
              ]),
              const SizedBox(height: AppDimensions.mediumSpacing),
              // 책소개
              _buildInfoBox("책소개", [
                if (widget.book['description'] != "")
                  Text(
                    widget.book['description'],
                    style: AppStyles.bodyStyle
                        .copyWith(fontSize: 16, color: Colors.black),
                  )
                else
                  Text(
                    '책소개가 없습니다.',
                    style: AppStyles.bodyStyle
                        .copyWith(fontSize: 16, color: Colors.black),
                  )
              ]),
              const SizedBox(height: AppDimensions.mediumSpacing),
              // 목차
              _buildInfoBox("목차", [
                // Assuming the 'contents' is a list of chapter names
                if (widget.book['bookinfo']['toc'] != "")
                  Text(
                    cleanText(widget.book['bookinfo']['toc']),
                    style: AppStyles.bodyStyle
                        .copyWith(fontSize: 16, color: Colors.black),
                  )
                else
                  Text(
                    '책의 목차 정보가 없습니다.',
                    style: AppStyles.bodyStyle
                        .copyWith(fontSize: 16, color: Colors.black),
                  )
              ]),
              const SizedBox(height: AppDimensions.largeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a box for different sections
  Widget _buildInfoBox(String title, List<Widget> contentWidgets) {
    bool isExpanded = _expandedSections[title] ?? false;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: AppColors.lightCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.jua(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // 펼쳐질 내용
          AnimatedCrossFade(
            // firstChild: SizedBox.shrink(),
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 60, // Fixed height instead of a ratio
                child: Text(
                  cleanText((contentWidgets.first as Text).data ?? ''),
                  style: GoogleFonts.jua(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentWidgets,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 100),
          ),

          // 중앙 아래에 화살표 버튼
          Center(
            child: GestureDetector(
              onTap: () => _toggleSection(title),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 30,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryTags(String categoryString) {
    // Split the string by '>' and remove any whitespace
    final categories = categoryString
        .split('>')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Wrap(
      spacing: 8, // gap between adjacent chips
      runSpacing: 8, // gap between lines
      children: categories
          .map((category) => Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(16),
                  // border: Border.all(color: Color(0xFF9AD9B8)),
                ),
                child: Text(
                  '#$category',
                  style: GoogleFonts.jua(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
