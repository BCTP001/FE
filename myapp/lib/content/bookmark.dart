import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../content/bookinfo.dart';
import '../component/graphql_client.dart';
import '../component/util.dart';

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
          backgroundColor: Color(0xFF938971),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSortBar(),
                SizedBox(height: 20),
                Expanded(child: _buildBookGrid()),
                SizedBox(height: 40),
              ],
            ),
          ),
        ));
  }

  Widget _buildBookGrid() {
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
                        Text.rich(TextSpan(
                          text: '검색결과',
                          style: GoogleFonts.jua(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: ' (${books.length})권',
                              style: GoogleFonts.jua(
                                  fontSize: 24,
                                  color: AppColors.darkGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        SizedBox(height: 8),
                        Expanded(
                          // Add this Expanded widget
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  200, // Maximum width of each grid item
                              crossAxisSpacing: 16.0, // Spacing between columns
                              mainAxisSpacing: 16.0, // Spacing between rows
                              childAspectRatio: 0.65,
                            ),
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              return _buildBookCard(books[index], context);
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ]));
  }

  Widget _buildBookCard(dynamic book, BuildContext context) {
    String bookId = book['isbn13'];

    return Consumer<BookmarksProvider>(
        builder: (context, bookmarksProvider, child) {
      bool isBookmarked = true;

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
          color: Color(0xFF938971),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment
                .center, // Changed to Row for horizontal layout
            children: [
              Expanded(
                flex: 3, // Book cover takes more space
                child: buildBookCover(book['cover'], 200, 280),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<List<dynamic>> getBooksInShelf() async {
    try {
      final result = await GraphQLService.getBooksInShelf('default');
      if (result.isNotEmpty) {
        debugPrint('Get books in shelf successfully');
        return result;
      } else {
        debugPrint('Failed to get books in shelf');
        return [];
      }
    } catch (e) {
      debugPrint('Error in getting books in shelf: $e');
      return [];
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF938971),
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightCream,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '나만의 책장',
          style: GoogleFonts.nanumPenScript(
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
