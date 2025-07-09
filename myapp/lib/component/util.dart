import 'package:flutter/material.dart';
import '../component/graphql_client.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme color definitions
class AppColors {
  static const Color primaryGreen = Color(0xFFABF4D0);
  static const Color darkGreen = Color(0xFF037549);
  static const Color lightGreen = Color(0xFF28DF99);
  static const Color primaryBrown = Color(0xFF3E2723);
  static const Color lightBrown = Color(0xFFD0C38F);
  static const Color lightCream = Color(0xFFF8E6C8);
  static const Color lightYellow = Color(0xFFFFDBAD);
}

/// Layout spacing and sizing
class AppDimensions {
  static const double defaultPadding = 24.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 40.0;
  static const double buttonHeight = 50.0;
  static const double borderRadius = 8.0;
  static const double bookLogoWidth = 225.0;
  static const double bookLogoHeight = 284.0;
}

/// Typography styles
class AppStyles {
  static TextStyle get titleStyle => GoogleFonts.nanumPenScript(
        fontSize: 40,
        color: Colors.black,
      );

  static TextStyle get headerStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get subHeaderStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyStyle => GoogleFonts.jua(
        fontSize: 18,
        color: Colors.black,
      );

  static TextStyle get labelStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get captionStyle => const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      );
}

// -------------------------------
// Common Reusable Widgets
// -------------------------------
class CommonWidgets {
  /// Book Logo with title overlay
  static Widget buildBookLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/book.png',
          fit: BoxFit.contain,
          width: AppDimensions.bookLogoWidth,
          height: AppDimensions.bookLogoHeight,
        ),
        Positioned(
          child: Text(
            '오늘의 책',
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Custom text input field
  static Widget buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isPassword = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelStyle),
        const SizedBox(height: AppDimensions.smallSpacing),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBrown,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.mediumSpacing,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    Color backgroundColor = AppColors.primaryBrown,
    Color foregroundColor = Colors.white,
    bool isLoading = false,
    double? width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(width ?? double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );
  }

  static Widget buildSecondaryButton({
    required String text,
    required VoidCallback? onPressed,
    double? width,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBrown,
        foregroundColor: Colors.black,
        minimumSize: Size(width ?? double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
      child: Text(text),
    );
  }

  static Widget buildNextButton({
    required VoidCallback onPressed,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightCream,
          foregroundColor: Colors.black,
          minimumSize: const Size(100, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
        child: const Text("다음"),
      ),
    );
  }

  static AppBar buildAppBar({VoidCallback? onBackPressed}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed,
      ),
    );
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

Widget buildBookCover(String? coverUrl, double x, double y) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: coverUrl != null
        ? Image.network(
            coverUrl,
            width: x,
            height: y,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.book, size: 100);
            },
          )
        : const Icon(Icons.book, size: 100),
  );
}

class BookmarksProvider extends ChangeNotifier {
  final List<String> _bookmarkedBooks = [];
  final List<String> _excludedBookmarked = [];

  List<String> get bookmarkedBooks => _bookmarkedBooks;

  Future<void> addBookmark(String bookId) async {
    _bookmarkedBooks.add(bookId);
    await _updateShelf();
    notifyListeners();
  }

  Future<void> removeBookmark(String bookId) async {
    _bookmarkedBooks.remove(bookId);
    _excludedBookmarked.add(bookId);
    await _updateShelf();
    notifyListeners();
  }

  Future<void> _updateShelf() async {
    try {
      debugPrint(_bookmarkedBooks.toString());
      debugPrint(_excludedBookmarked.toString());
      final shelfResult = await GraphQLService.updateShelf(
          'default', _bookmarkedBooks, _excludedBookmarked);
      if (shelfResult != null) {
        debugPrint('Default shelf updated successfully');
      } else {
        debugPrint('Failed to update default shelf');
      }
    } catch (e) {
      debugPrint('Error update default shelf: $e');
    }
  }

  bool isBookmarked(String bookId) {
    return _bookmarkedBooks.contains(bookId);
  }
}
