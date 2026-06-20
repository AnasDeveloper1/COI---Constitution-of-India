import 'package:flutter/material.dart';
import '../screens/bookmark_share_helper.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final String title;
  final String description;

  const ArticleDetailsScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  void checkIfSaved() async {
    List<String> allSaved = await BookmarkShareHelper.getRawBookmarks();
    setState(() {
      isSaved = allSaved.contains(widget.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            color: isSaved ? Colors.amber : null,
            onPressed: () async {
              // FIX: Pass both widget.title and widget.description inside the parentheses
              bool status = await BookmarkShareHelper.toggleBookmark(widget.title, widget.description);

              if (mounted) {
                setState(() {
                  isSaved = status;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              BookmarkShareHelper.shareContent(widget.title, widget.description);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}