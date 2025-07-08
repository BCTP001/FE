import 'package:flutter/material.dart';
import 'graphql_client.dart';

class BookmarksProvider extends ChangeNotifier {
  final List<String> _bookmarkedBooks = [];
  final List<String> _excludedBookmarked = [];

  List<String> get bookmarkedBooks => _bookmarkedBooks;

  Future<void> addBookmark(String bookId) async {
    _bookmarkedBooks.add(bookId);
    await _updateShelf();
    notifyListeners();
  }

  Future<void> removeBookmark(String bookId) async {
    _bookmarkedBooks.remove(bookId);
    _excludedBookmarked.add(bookId);
    await _updateShelf();
    notifyListeners();
  }

  Future<void> _updateShelf() async {
    try {
      debugPrint(_bookmarkedBooks.toString());
      debugPrint(_excludedBookmarked.toString());
      final shelfResult = await GraphQLService.updateShelf(
          'default', _bookmarkedBooks, _excludedBookmarked);
      if (shelfResult != null) {
        debugPrint('Default shelf updated successfully');
      } else {
        debugPrint('Failed to update default shelf');
      }
    } catch (e) {
      debugPrint('Error update default shelf: $e');
    }
  }

  bool isBookmarked(String bookId) {
    return _bookmarkedBooks.contains(bookId);
  }
}