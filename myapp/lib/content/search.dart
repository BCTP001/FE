import 'package:flutter/material.dart';
// import '../placeholder/placeholder_image_with_text.dart';
import '../domains/booksearch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class SearchContent extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
  //   var columnCount = isLandscape ? 3 : 2;

  //   return Container(
  //     padding: EdgeInsets.only(left: 8, right: 8, top: 20),
  //     child: GridView.count(
  //       crossAxisCount: columnCount,
  //       children: List.generate(20, (index) {
  //         return PlaceholderImageWithText(
  //             color: Color(0xFF99D3F7), backgroundColor: Color(0xFFC7EAFF));
  //       }),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://scaling-waddle-pwvp6rwx6rxc6j5r-8080.app.github.dev/");
    
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
