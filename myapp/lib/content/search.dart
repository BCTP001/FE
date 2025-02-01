import 'package:flutter/material.dart';
import '../domains/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://scaling-waddle-pwvp6rwx6rxc6j5r-4000.app.github.dev/");
    
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
        home: BookSearchContent(),
      )
    );
  }
}
