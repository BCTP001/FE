import 'package:flutter/material.dart';
import '../component/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

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
        child: MaterialApp(
          title: 'GraphQL Book Search',
          home: BookSearchContent(),
        ));
  }
}
