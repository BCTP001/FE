import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../component/graphql_client.dart';
import '../content/bookinfo.dart';
import 'package:provider/provider.dart';

class BookmarkContent extends StatefulWidget {
  const BookmarkContent({super.key});
  @override
  State<BookmarkContent> createState() => _BookmarkContentState();
}

class _BookmarkContentState extends State<BookmarkContent> {
  List<dynamic> books = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await getBooksInShelf();
      setState(() {
        books = result; // Now books is List<dynamic>
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = GraphQLService.getClient();
    return GraphQLProvider(
        client: client,
        child: Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Color(0xFF80471C),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSortBar(),
                SizedBox(height: 20),
                _buildBookGrid(2)
              ],
            ),
          ),
        ));
  }

  Widget _buildBookGrid(int columnCount) {
    return Expanded(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : books.isEmpty
                ? Center(
                    child: Text(
                    '검색 결과가 없습니다.',
                    style: GoogleFonts.jua(fontSize: 24, color: Colors.white),
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          '검색결과',
                          style: GoogleFonts.jua(
                              fontSize: 24, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          // Add this Expanded widget
                          child: ListView.builder(
                            itemCount: books.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                _buildBookCard(books[index], context),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ]));
  }

  Widget _buildBookCard(dynamic book, BuildContext context) {
    String bookId = book['isbn'];

    return Consumer<BookmarksProvider>(
        builder: (context, bookmarksProvider, child) {
      bool isBookmarked = bookmarksProvider.isBookmarked(bookId);

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(
                book: book,
                isInitiallyBookmarked: isBookmarked,
                onBookmarkToggle: (String id) {
                  if (bookmarksProvider.isBookmarked(id)) {
                    bookmarksProvider.removeBookmark(id);
                  } else {
                    bookmarksProvider.addBookmark(id);
                  }
                },
              ),
            ),
          );
        },
        child: Card(
          color: Color(0xFF80471C),
          margin: EdgeInsets.symmetric(vertical: 4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            height: 180, // Fixed height for the card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Changed to Row for horizontal layout
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: _buildBookCover(book['cover']),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBookCover(String? coverUrl) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: coverUrl != null
            ? Image.network(
                coverUrl,
                width: 100,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.book, size: 100);
                },
              )
            : const Icon(Icons.book, size: 100));
  }

  Future<List<dynamic>> getBooksInShelf() async {
    try {
      final result = await GraphQLService.getBooksInShelf('default');
      if (result.isNotEmpty) {
        debugPrint('Default shelf created successfully');
        return result;
      } else {
        debugPrint('Failed to create default shelf');
        return [];
      }
    } catch (e) {
      debugPrint('Error creating default shelf: $e');
      return [];
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF80471C),
      centerTitle: true,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE5D8BE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '나만의 책장',
          style: GoogleFonts.nanumBrushScript(
            fontSize: 40,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      toolbarHeight: 100,
    );
  }

  Widget _buildSortBar() {
    bool isListView = true; // true for list view, false for grid view
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Sort icon and text
            Row(
              children: [
                Icon(Icons.swap_vert, size: 28, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '최근',
                  style: GoogleFonts.jua(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Right side: Single view toggle icon
            GestureDetector(
              onTap: () {
                setState(() {
                  isListView = !isListView; // Toggle between list and grid view
                });
                // Add your function to change the view here
              },
              child: Icon(
                isListView ? Icons.format_list_bulleted : Icons.grid_view,
                size: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }
}

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
