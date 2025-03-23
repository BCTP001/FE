import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookmarkContent extends StatefulWidget {
  const BookmarkContent({super.key});
  @override
  State<BookmarkContent> createState() => _BookmarkContentState();
}

class _BookmarkContentState extends State<BookmarkContent> {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        "https://organic-space-bassoon-r69pxg6jx7xcxppw-4000.app.github.dev/");
  
    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );
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
              // _write_graphql_provider(columnCount),
            ],
          ),
        ),
      )
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF80471C),
      centerTitle: true,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8DCC4),
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
  final Set<String> _bookmarkedBooks = {};
  
  Set<String> get bookmarkedBooks => _bookmarkedBooks;
  
  void addBookmark(String bookId) {
    _bookmarkedBooks.add(bookId);
    notifyListeners();
  }
  
  void removeBookmark(String bookId) {
    _bookmarkedBooks.remove(bookId);
    notifyListeners();
  }
  
  bool isBookmarked(String bookId) {
    return _bookmarkedBooks.contains(bookId);
  }
}