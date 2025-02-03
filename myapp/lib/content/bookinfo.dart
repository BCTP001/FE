import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

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
      body: SingleChildScrollView(  // Added ScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCover(book['cover']),
              const SizedBox(height: 16),
              Text(
                book['title'] ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                book['author'] ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: buildCategoryTags(book['categoryName']),
              ),
              const SizedBox(height: 16),
              Text(
                book['description'] ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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

  Widget buildCategoryTags(String categoryString) {
    // Split the string by '>' and remove any whitespace
    final categories = categoryString.split('>')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Wrap(
      spacing: 8, // gap between adjacent chips
      runSpacing: 8, // gap between lines
      children: categories.map((category) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF28DF99),
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: Color(0xFF7EEDC3)),
        ),
        child: Text(
          category,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      )).toList(),
    );
  }
}