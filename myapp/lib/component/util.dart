import 'package:flutter/material.dart';

Widget buildBookCover(String? coverUrl, double x, double y) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: coverUrl != null
        ? Image.network(
            coverUrl,
            width: x,
            height: y,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.book, size: 100);
            },
          )
        : const Icon(Icons.book, size: 100),
  );
}