import 'dart:convert';
import 'package:constitutionofindia/screens/bookmark_share_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';


class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, String>> _allNotes = [];
  List<Map<String, String>> _filteredNotes = [];

  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _showOnlyBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // 1. Load Notes from storage
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('user_notes');

    if (notesString != null) {
      final List<dynamic> decoded = jsonDecode(notesString);
      setState(() {
        _allNotes = decoded.map((item) => Map<String, String>.from(item)).toList();
        _applyFiltersAndSearch();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Save Notes to storage
  Future<void> _saveNotesToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_allNotes);
    await prefs.setString('user_notes', encoded);
  }

  // 3. Filter and Search processing
  void _applyFiltersAndSearch() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        bool matchesSearch = (note['title'] ?? '').toLowerCase().contains(query) ||
            (note['content'] ?? '').toLowerCase().contains(query);
        bool matchesBookmarkFilter = !_showOnlyBookmarked || (note['isBookmarked'] == 'true');
        return matchesSearch && matchesBookmarkFilter;
      }).toList();
    });
  }

  // 4. Centered Alert Dialog Popup UI: Create or Edit Note Form
  void _showNoteDialog({int? index}) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    if (index != null) {
      final originalIndex = _allNotes.indexOf(_filteredNotes[index]);
      titleController.text = _allNotes[originalIndex]['title'] ?? '';
      contentController.text = _allNotes[originalIndex]['content'] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
            index == null ? "New Note" : "Edit Note",
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85, 
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4), 
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: "Write something...",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),
        ), 
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              
              String oldTitle = "";
              bool wasBookmarked = false;
              
              if (index != null) {
                final originalIndex = _allNotes.indexOf(_filteredNotes[index]);
                oldTitle = _allNotes[originalIndex]['title'] ?? '';
                wasBookmarked = _allNotes[originalIndex]['isBookmarked'] == 'true';
              }

              setState(() {
                if (index == null) {
                  _allNotes.insert(0, {
                    'title': titleController.text,
                    'content': contentController.text,
                    'isBookmarked': 'false',
                  });
                } else {
                  final originalIndex = _allNotes.indexOf(_filteredNotes[index]);
                  _allNotes[originalIndex]['title'] = titleController.text;
                  _allNotes[originalIndex]['content'] = contentController.text;
                }
                _applyFiltersAndSearch();
              });
              
              await _saveNotesToDisk();

              // If an edited note was already bookmarked, update global bookmarks with the new changes
              if (index != null && wasBookmarked) {
                await BookmarkShareHelper.forceRemoveBookmark("[Note] $oldTitle");
                await BookmarkShareHelper.toggleBookmark("[Note] ${titleController.text}", contentController.text);
              }

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // 5. Toggle Bookmark (Modified to update Global Bookmarks Helper)
  void _toggleBookmark(int index) async {
    final originalIndex = _allNotes.indexOf(_filteredNotes[index]);
    final note = _allNotes[originalIndex];
    final String noteTitle = note['title'] ?? 'Untitled Note';
    final String noteContent = note['content'] ?? '';

    setState(() {
      bool currentStatus = note['isBookmarked'] == 'true';
      _allNotes[originalIndex]['isBookmarked'] = currentStatus ? 'false' : 'true';
      _applyFiltersAndSearch();
    });
    
    await _saveNotesToDisk();
    
    // Prefixing with '[Note] ' keeps it distinct inside the bookmark data pool
    await BookmarkShareHelper.toggleBookmark("[Note] $noteTitle", noteContent);
  }

  // 6. Delete Note (Modified to remove from Global Bookmarks instantly if present)
  void _deleteNote(int index) async {
    final originalIndex = _allNotes.indexOf(_filteredNotes[index]);
    final note = _allNotes[originalIndex];
    final String noteTitle = note['title'] ?? '';

    if (note['isBookmarked'] == 'true') {
      await BookmarkShareHelper.forceRemoveBookmark("[Note] $noteTitle");
    }

    setState(() {
      _allNotes.removeAt(originalIndex);
      _applyFiltersAndSearch();
    });
    
    await _saveNotesToDisk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _applyFiltersAndSearch(),
                    decoration: InputDecoration(
                      hintText: "Search notes...",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _applyFiltersAndSearch();
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showNoteDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("New Note", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredNotes.isEmpty
                ? const Center(child: Text("No notes found.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                bool isNoteBookmarked = note['isBookmarked'] == 'true';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
                    onTap: () => _showNoteDialog(index: index),
                    title: Text(
                      note['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        note['content'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(isNoteBookmarked ? Icons.bookmark : Icons.bookmark_border),
                          color: isNoteBookmarked ? Colors.amber : Colors.grey,
                          onPressed: () => _toggleBookmark(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blue, size: 22),
                          onPressed: () {
                            Share.share("${note['title']}\n\n${note['content']}");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                          onPressed: () => _deleteNote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}