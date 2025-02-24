import 'package:flutter/material.dart';
import '../component/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        "https://glowing-spoon-4w56p7vw9rwfjqr6-4000.app.github.dev/");

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
