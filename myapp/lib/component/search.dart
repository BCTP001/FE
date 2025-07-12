import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../content/bookinfo.dart';
import 'util.dart';

class BookSearchContent extends StatefulWidget {
  const BookSearchContent({super.key});

  @override
  State<BookSearchContent> createState() => _BookSearchContentState();
}

class _BookSearchContentState extends State<BookSearchContent> {
  List<dynamic> books = [];
  bool isLoading = false;
  bool isSearchPerformed = false;
  String selectedSearchType = '제목+저자';
  TextEditingController searchController = TextEditingController();

  Future<void> searchBooks(String searchQuery) async {
    setState(() {
      isLoading = true;
      isSearchPerformed = true;
    });
    String queryType;
    switch (selectedSearchType) {
      case '제목+저자':
        queryType = "Keyword";
      case '제목':
        queryType = "Title";
      case '저자':
        queryType = "Author";
      default:
        queryType = "Keyword";
    }

    final searchOption =
        SearchOption(searchQuery: searchQuery, queryType: queryType);

    final QueryOptions options = QueryOptions(
      document: gql(searchBooksQuery),
      variables: {
        'searchOption': searchOption.toJson(),
      },
    );

    try {
      final QueryResult result =
          await GraphQLProvider.of(context).value.query(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        setState(() {
          books = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        books = result.data?['searchBooksAndGetBookInfo'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error searching books: $e');
      setState(() {
        books = [];
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var columnCount = 2;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color(0xFF938971),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildBookGrid(columnCount),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFFFFAE3),
      centerTitle: true,
      title: Text(
        '어떤 책을 찾으시나요?',
        style: GoogleFonts.nanumPenScript(
          fontSize: 40,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      toolbarHeight: 100,
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        _buildSearchTypeDropdown(),
        _buildSearchTextField(),
      ],
    );
  }

  Widget _buildSearchTypeDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: 48,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF0ECB2),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedSearchType,
            items: ['제목+저자', '제목', '저자'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.jua(fontSize: 16, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedSearchType = newValue;
                  searchController.clear();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Expanded(
      child: TextField(
        controller: searchController,
        style: GoogleFonts.jua(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF0ECB2),
          hintText: '원하시는 책을 검색해보세요',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: searchBooks,
      ),
    );
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
          child: Container(
            height: 180, // Fixed height for the card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Changed to Row for horizontal layout
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: buildBookCover(book['cover'], 100, 150),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: _buildBookInfo(book),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark_added : Icons.bookmark_add,
                    size: 40,
                    color: isBookmarked
                        ? const Color.fromARGB(255, 58, 10, 10)
                        : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isBookmarked) {
                        bookmarksProvider.removeBookmark(bookId);
                      } else {
                        bookmarksProvider.addBookmark(bookId);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBookInfo(dynamic book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book['title'],
          style: GoogleFonts.jua(fontSize: 14, color: Colors.white),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          book['categoryName'],
          style: GoogleFonts.jua(
            fontSize: 13,
            color: Color(0xFFFFFAE3),
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class SearchOption {
  final String? searchQuery;
  final String? queryType;

  SearchOption({this.searchQuery, this.queryType});

  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'sort': "Accuracy",
      'queryType': queryType,
    };
  }
}

const String searchBooksQuery = """
  query ExampleQuery(\$searchOption: SearchOption!) {
  searchBooksAndGetBookInfo(searchOption: \$searchOption) {
    title
    author
    cover
    categoryName
    isbn
    description
    pubDate
    bookinfo {
      itemPage
      toc
    }
    isbn13
  }
}
""";
