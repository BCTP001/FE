import 'package:flutter/material.dart';
import '../component/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        "https://ubiquitous-space-orbit-w56g475w9rx2g7v4-4000.app.github.dev/");

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
        ));
  }
}
