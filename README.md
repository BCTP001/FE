# BookRecs-Front

This Flutter application allows users to:

- View current popular books from **Aladin API**
- Search for books by keyword
- Bookmark favorite books

## features

- 🎯 Home screen displaying daily featured books
- 🔍 Book search using GraphQL
- 📚 Bookmark functionality to save your favorite books
- 📱 Responsive and elegant UI using custom themes and styles

## Getting Started

### 🚀 Installation
```bash
git clone <this-repo-url>
cd myapp
flutter pub get
flutter run -d web-server --web-hostname=0.0.0.0
```

📁 `lib/component/graphql_client.dart` line 7

Set up the GraphQL client for querying data from your backend API:
```dart
final HttpLink httpLink = HttpLink(
  'https://your-backend-api/graphql', // Replace with your actual backend GraphQL endpoint
);
```

### 🔧 Build Android app
```bash
docker build .
flutter build apk
```

### For Backend Installation
1. git clone https://github.com/BCTP001/be
2. make be/.env and add your aladin api
3. sh run.sh

Implements the fluid navigation bar using `fluid_nav_bar`. For reference, see:
[https://github.com/eric-taix/fluid-nav-bar](https://github.com/eric-taix/fluid-nav-bar)