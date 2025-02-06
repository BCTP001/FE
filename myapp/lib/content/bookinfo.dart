import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  final dynamic book;
  
  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Map<String, bool> _expandedSections = {
    "도서정보": false,
    "목차": false,
    "책소개": false,
  };
  
  void _toggleSection(String title) {
    setState(() {
      _expandedSections[title] = !_expandedSections[title]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EEDC3),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFF7EEDC3),
      body: SingleChildScrollView(  // ScrollView for the entire body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCover(widget.book['cover']),
              const SizedBox(height: 16),
              Text(
                widget.book['title'] ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.book['author'] ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              
              // 도서정보
              _buildInfoBox("도서정보", [
                Text("발행일: ${widget.book['pubDate'] ?? ''}", style: Theme.of(context).textTheme.titleMedium,),
                Text("${widget.book['itemPage'] ?? ''}쪽"),
                Text("ISBN: ${widget.book['isbn'] ?? ''}", style: Theme.of(context).textTheme.titleMedium,),
              ]),
              
              const SizedBox(height: 16),
              // 목차
              _buildInfoBox( "목차", [
                // Assuming the 'contents' is a list of chapter names
                if (widget.book['bookinfo']['toc'] != null) 
                  Text(widget.book['bookinfo']['toc'].toString())
                else
                  Text("No table of contents available."),
              ]),
              
              const SizedBox(height: 16),
              
              // 책소개
              _buildInfoBox( "책소개", [
                Text(widget.book['description'] ?? 'No description available.'),
              ]),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),

          // 펼쳐질 내용
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(), 
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentWidgets,
              ),
            ),
            crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),

          // 중앙 아래에 화살표 버튼
          Center(
            child: GestureDetector(
              onTap: () => _toggleSection(title),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
  Widget _buildBookCover(String? coverUrl) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final imageWidth = screenWidth * 0.3; // Reduced to 35% of screen width
        final imageHeight = imageWidth * 1;

        return Center(
          child: coverUrl != null
                ? Image.network(
                    coverUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.book, size: imageWidth);
                    },
                  )
                : Icon(Icons.book, size: imageWidth),
          );
      },
    );
  }
}