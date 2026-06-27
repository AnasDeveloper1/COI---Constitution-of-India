import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class BookmarkShareHelper {
  static const String _key = "my_bookmarks_v2"; 
  static const String _termsKey = "has_accepted_terms_v1"; // Key for terms state

  // Native System Sharing Handler
  static void shareContent(String title, String description) {
    Share.share("$title\n\n$description\n\nShared via Constitution of India App");
  }

  // Fetch bookmarks from phone disk memory
  static Future<List<String>> getRawBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Explicit check to see if a specific title is bookmarked
  static Future<bool> isBookmarked(String title) async {
    final currentList = await getRawBookmarks();
    return currentList.any((item) => item.startsWith("$title|||"));
  }

  // Save or Remove an item containing BOTH Title and Description
  static Future<bool> toggleBookmark(String title, String description) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_key) ?? [];

    String combinedData = "$title|||$description";
    bool isNowSaved;

    int existingIndex = currentList.indexWhere((item) => item.startsWith("$title|||"));

    if (existingIndex != -1) {
      currentList.removeAt(existingIndex);
      isNowSaved = false;
      print("DEBUG BOOKMARKS: Removed '$title'");
    } else {
      currentList.add(combinedData);
      isNowSaved = true;
      print("DEBUG BOOKMARKS: Added '$title'");
    }

    await prefs.setStringList(_key, currentList);
    return isNowSaved;
  }

  // Explicitly remove a bookmark (used when a note is deleted entirely)
  static Future<void> forceRemoveBookmark(String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_key) ?? [];
    currentList.removeWhere((item) => item.startsWith("$title|||"));
    await prefs.setStringList(_key, currentList);
  }

  // --- NEW: Check if the user already accepted the terms ---
  static Future<bool> hasAcceptedTerms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_termsKey) ?? false;
  }

  // --- NEW: Saves the user's acceptance status ---
  static Future<void> acceptTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsKey, true);
  }
}
