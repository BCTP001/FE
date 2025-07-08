import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../component/graphql_client.dart';
import '../content/bookinfo.dart';
import '../component/bookmarkprovider.dart';
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
          backgroundColor: Color(0xFF938971),
          body: Padding(
            padding: EdgeInsets.all(26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSortBar(),
                SizedBox(height: 10),
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
    String bookId = book['isbn13'];

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
          color: Color(0xFF938971),
          margin: EdgeInsets.symmetric(vertical: 4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SizedBox(
            height: 120, // Fixed height for the card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment
                  .start, // Changed to Row for horizontal layout
              children:[
                _buildBookCover(book['cover']),
                SizedBox(width: 20,),
                _buildBookInfo(book['title'], book['author'])
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
                width: 80,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.book, size: 80);
                },
              )
            : const Icon(Icons.book, size: 80));
  }

  Widget _buildBookInfo(String? titleUrl, String? authorUrl){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child:Text(
            titleUrl ?? '', 
            style: GoogleFonts.jua(
                fontSize: 14, 
                color: Colors.white
              ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 8,),
        Text(
          authorUrl ?? '',
          style: GoogleFonts.jua(
            fontSize: 14,
            color: Colors.white,
          ),
        ),        
      ],
    );
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
      title: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0ECB2),
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
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Sort icon and text
            Row(
              children: [
                Icon(Icons.swap_vert, size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '최근',
                  style: GoogleFonts.jua(
                    fontSize: 20,
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
        );
    });
  }
}


