import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../content/bookinfo.dart';

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
    };
    final searchOption = SearchOption(searchQuery: searchQuery, queryType: queryType);
    
    final QueryOptions options = QueryOptions(
      document: gql(searchBooksQuery),
      variables: {
        'searchOption': searchOption.toJson(),
      },
    );
    
    try {
      final QueryResult result = await GraphQLProvider.of(context).value.query(options);
      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        setState((){
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
      print('Error searching books: $e');
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
    var columnCount = 3;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color(0xFF80471C),
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
      backgroundColor: Color(0xFF7EEDC3),
      centerTitle: true,
      title: Text(
        '어떤 책을 찾으시나요?',
        style: GoogleFonts.nanumBrushScript(
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
          color: Color(0xFFE8DCC4),
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
                  style: GoogleFonts.jua( 
                    fontSize: 16,
                    color: Colors.black
                ),
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
        style: GoogleFonts.jua( 
          fontSize: 16,
          color: Colors.black
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFE8DCC4),
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
                style: GoogleFonts.jua( 
                    fontSize: 24,
                    color: Colors.white
                ),
              )
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[ 
                Text(
                  '검색결과',
                  style: GoogleFonts.jua( 
                    fontSize: 24,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      shrinkWrap: true,
                      itemCount: books.length,
                      itemBuilder: (context, index) => _buildBookCard(books[index], context),
                  ),
                )
              ]
            )
    );
  }

  Widget _buildBookCard(dynamic book, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Card(
        color: Color(0xFF80471C),
        margin: EdgeInsets.zero,
        child: LayoutBuilder(
          builder: (context, constraints) =>  
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.6,  // 60% of available height
                  child: _buildBookCover(book['cover']),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.4,  // 40% of available height
                  child: _buildBookInfo(book),
                ),
              ],
            )
        ),
      ),
    );
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
        : const Icon(Icons.book, size: 100)
    );
  }

  Widget _buildBookInfo(dynamic book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book['title'],
          style: GoogleFonts.jua( 
            fontSize: 14,
            color: Colors.white
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          book['categoryName'],
          style: GoogleFonts.jua( 
            fontSize: 13,
            color: Color(0xFF7EEDC3),
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
  query ExampleQuery(\$searchOption: SearchOption) {
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
  }
}
""";