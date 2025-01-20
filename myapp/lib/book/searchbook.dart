// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Define the search option input type
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

final log = Logger('BookSearch');

const String searchBooksQuery  = """
  query ExampleQuery(\$searchOption: SearchOption) {
  searchBooks(searchOption: \$searchOption) {
    title
    author
    cover
    categoryName
  }
}
""";


void main() async {
  await initHiveForFlutter();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    //initialize httplink
    //set up the right link from backend and make it public!!!
    final HttpLink httpLink = HttpLink("https://scaling-waddle-pwvp6rwx6rxc6j5r-8080.app.github.dev/");
    
    //create graphql client
    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    ); 
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'GraphQL Book Search',
        home: BookSearchScreen(),
      )
    );
  }
}
class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  List<dynamic> books = [];
  bool isLoading = false;

  Future<void> searchBooks(String searchQuery) async {
    setState(() {
      isLoading = true;
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
        log.severe('Error: ${result.exception.toString()}');
        return;
      }
      
      setState(() {
        books = result.data?['searchBooks'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      log.severe('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '도서를 검색하세요',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                searchBooks(value);
              },
            ),
          ),
          if (isLoading) 
            CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return ListTile(
                    title: Text(book['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[ 
                        Text(book['author']),
                        Text(book['categoryName']),
                      ],
                    ),
                    leading: book['cover'] != null
                      ? Image.network( 
                        book['cover'],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.book);
                        },
                      )
                    : const Icon(Icons.book),
                  );
                }
              )
            )
        ],
      )
    );
  }
}
