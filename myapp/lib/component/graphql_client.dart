import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static ValueNotifier<GraphQLClient>? _client;
  static const String _baseUrl =
      "https://cuddly-eureka-v77v7pr94qg36xrx-4000.app.github.dev/";
  /// Get or initialize GraphQL client
  static ValueNotifier<GraphQLClient> getClient() {
    if (_client == null) {
      // Initialize GraphQL client
      final HttpLink httpLink = HttpLink(_baseUrl);

      // Create the GraphQL client
      _client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: httpLink,
          cache: GraphQLCache(),
        ),
      );
    }

    return _client!;
  }

  /// Sign in with username and password
  ///
  /// Returns user data and token on success, null on failure
  static Future<Map<String, dynamic>?> signIn(
      String username, String password) async {
    final GraphQLClient client = getClient().value;

    const String signInMutation = '''
      mutation SignIn(\$username: String!, \$password: String!) {
        signIn(username: \$username, password: \$password) {
          signedInAs {
            id
            name
            username
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(signInMutation),
      variables: {
        'username': username,
        'password': password,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return null;
      }
      return result.data;
    } catch (e) {
      debugPrint('Error in signIn: $e');
      return null;
    }
  }

  /// Sign up with name, username and password
  ///
  /// Returns user data on success, null on failure
  static Future<Map<String, dynamic>?> signUp(
      String name, String username, String password) async {
    final GraphQLClient client = getClient().value;

    const String signUpMutation = '''
      mutation SignUp(\$name: String!, \$username: String!, \$password: String!) {
        signUp(name: \$name, username: \$username, password: \$password) {
          id
          name
          username
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(signUpMutation),
      variables: {
        'name': name,
        'username': username,
        'password': password,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return null;
      }
      return result.data;
    } catch (e) {
      debugPrint('Error in signUp: $e');
      return null;
    }
  }

  /// Sign out current user
  ///
  /// Returns success status
  static Future<bool> signOut() async {
    final GraphQLClient client = getClient().value;

    const String signOutMutation = '''
      mutation SignOut {
        signOut
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(signOutMutation),
    );

    try {
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return false;
      }
      return result.data?['signOut'] == true;
    } catch (e) {
      debugPrint('Error in signOut: $e');
      return false;
    }
  }

  /// Create a new shelf with given name
  ///
  /// Returns success message
    static Future<Map<String, dynamic>?> createShelf(String shelfName, String userId) async {
    final GraphQLClient client = getClient().value;

    const String createShelfMutation = '''
      mutation CreateShelf(\$request: CreateShelfRequest!) {
        createShelf(request: \$request) {
          msg
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(createShelfMutation),
      variables: {
        'request': {
          'shelfName': shelfName,
          'userId': userId,
        }
      },
    );

    try {
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return null;
      }
      return result.data;
    } catch (e) {
      debugPrint('Error in createShelf: $e');
      return null;
    }
  }

  /// Update shelf contents with contain and exclude lists
  ///
  /// Returns updated shelf info
  static Future<Map<String, dynamic>?> updateShelf(String shelfName,
      List<String> containList, List<String> excludeList) async {
    final GraphQLClient client = getClient().value;

    const String updateShelfMutation = '''
      mutation UpdateShelf(\$request: UpdateShelfRequest!) {
        updateShelf(request: \$request) {
          msg
          shelfName
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(updateShelfMutation),
      variables: {
        'request': {
          "containList": containList,
          "excludeList": excludeList,
          "shelfName": shelfName
        }
      },
    );

    try {
      final QueryResult result = await client.mutate(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return null;
      }
      return result.data;
    } catch (e) {
      debugPrint('Error in updateShelf: $e');
      return null;
    }
  }

  /// Get books in a shelf by shelf name
  ///
  /// Returns list of books
  static Future<List<dynamic>> getBooksInShelf(String shelfName) async {
    final GraphQLClient client = getClient().value;

    const String getBooksQuery = '''
      query GetBooksInShelf(\$request: GetBooksInShelfRequest!) {
        getBooksInShelf(request: \$request) {
          title
          link
          author
          pubDate
          description
          creator
          isbn
          isbn13
          itemId
          cover
          categoryId
          categoryName
          publisher
          customerReivewRank
          bookinfo {
            itemPage
            toc
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getBooksQuery),
      variables: {
        'request': {"shelfName": shelfName}
      },
    );

    try {
      final QueryResult result = await client.query(options);
      if (result.hasException) {
        debugPrint('GraphQL Error: ${result.exception.toString()}');
        return [];
      }

      if (result.data != null && result.data!['getBooksInShelf'] != null) {
        return result.data!['getBooksInShelf'] as List<dynamic>;
      }

      return [];
    } catch (e) {
      debugPrint('Error in getBooksInShelf: $e');
      return [];
    }
  }
}
