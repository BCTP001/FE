import 'package:flutter/material.dart';
import '../component/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../component/graphql_client.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = GraphQLService.getClient();
    return GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'GraphQL Book Search',
          home: BookSearchContent(),
        ));
  }
}
