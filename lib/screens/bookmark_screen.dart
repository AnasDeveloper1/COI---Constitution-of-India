import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen_articles/amendmentdetailscreen.dart';
import 'bookmark_share_helper.dart'; 

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> rawSavedItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSavedItems();
  }

  void loadSavedItems() async {
    List<String> items = await BookmarkShareHelper.getRawBookmarks();
    if (mounted) {
      setState(() {
        rawSavedItems = items;
        loading = false;
      });
    }
  }

  // If a note gets un-bookmarked from here, we must flip the flag inside 'user_notes' JSON storage as well
  SystemNotesSyncHandler(String strippedTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('user_notes');
    if (notesString != null) {
      final List<dynamic> decoded = jsonDecode(notesString);
      List<Map<String, String>> allNotes = decoded.map((item) => Map<String, String>.from(item)).toList();
      
      int index = allNotes.indexWhere((note) => note['title'] == strippedTitle);
      if (index != -1) {
        allNotes[index]['isBookmarked'] = 'false';
        await prefs.setString('user_notes', jsonEncode(allNotes));
      }
    }
  }

  // Opens a neat modal view for custom text items inside bookmarks without crashing paths
  void _viewNoteModal(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Bookmarks"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : rawSavedItems.isEmpty
          ? const Center(
        child: Text(
          "No bookmarks saved yet.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rawSavedItems.length,
        itemBuilder: (context, index) {
          final parts = rawSavedItems[index].split("|||");
          final String displayTitle = parts[0];
          final String displayDescription = parts.length > 1 ? parts[1] : "";

          final bool isNote = displayTitle.startsWith("[Note] ");
          // UI cleanup to strip out the utility internal tags
          final String cleanTitle = isNote ? displayTitle.replaceFirst("[Note] ", "") : displayTitle;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                Icons.bookmark, 
                color: isNote ? Colors.blueAccent : Colors.amber
              ),
              title: Text(
                cleanTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: displayDescription.isNotEmpty
                  ? Text(
                displayDescription.replaceAll(RegExp(r'[\n\r]'), ' '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
                  : null,
              onTap: () async {
                if (isNote) {
                  _viewNoteModal(cleanTitle, displayDescription);
                  return;
                }

                // Default safe fallback route context logic for original Amendments
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AmendmentDetailScreen(
                      title: displayTitle,
                      description: displayDescription,
                    ),
                  ),
                );
                loadSavedItems();
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await BookmarkShareHelper.toggleBookmark(displayTitle, displayDescription);
                  if (isNote) {
                    await SystemNotesSyncHandler(cleanTitle);
                  }
                  loadSavedItems();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}