import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookSearchContent extends StatefulWidget {
  const BookSearchContent({super.key});

  @override
  State<BookSearchContent> createState() => _BookSearchContentState();
}

class _BookSearchContentState extends State<BookSearchContent> {
  List<dynamic> books = [];
  bool isLoading = false;
  bool isSearchPerformed = false;

  Future<void> searchBooks(String searchQuery) async {
    setState(() {
      isLoading = true;
      isSearchPerformed = true;
    });

    final searchOption = SearchOption(searchQuery: searchQuery);
    
    final QueryOptions options = QueryOptions(
      document: gql(searchBooksQuery),
      variables: {
        'searchOption': searchOption.toJson(),
      },
    );
    
    try {
      final QueryResult result = await GraphQLProvider.of(context).value.query(options);

      if (result.hasException) {
        return;
      }
      
      setState(() {
        books = result.data?['searchBooks'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    var columnCount = isLandscape ? 3 : 2;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '도서를 검색하세요',
              border: OutlineInputBorder(),
            ),
            onSubmitted: searchBooks,
          ),
        ),
        if (isLoading) 
          CircularProgressIndicator()
        else
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                childAspectRatio: 0.6,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  child: Column(
                    children: [
                      book['cover'] != null
                        ? Image.network(
                            book['cover'],
                            width: 200,
                            height: 280,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.book, size: 200);
                            },
                          )
                        : const Icon(Icons.book, size: 200),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              book['author'],
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          )
      ],
    );
  }
}

class SearchOption {
  final String? searchQuery;

  SearchOption({this.searchQuery});

  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'sort': "Accuracy"
    };
  }
}

const String searchBooksQuery = """
  query ExampleQuery(\$searchOption: SearchOption) {
  searchBooks(searchOption: \$searchOption) {
    title
    author
    cover
    categoryName
  }
}
""";