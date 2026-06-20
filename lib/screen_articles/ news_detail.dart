// lib/screen_articles/ news_detail.dart
import 'package:flutter/material.dart';

import '../screens/bookmark_share_helper.dart';

class NewsDetailScreen extends StatefulWidget {
  final String title;
  final String date;
  final String description;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.description,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    // Validates phone data disk states upon structural rendering layout stability
    WidgetsBinding.instance.addPostFrameCallback((_) => checkIfSaved());
  }

  void checkIfSaved() async {
    bool savedStatus = await BookmarkShareHelper.isBookmarked(widget.title);
    if (mounted) {
      setState(() {
        isSaved = savedStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        actions: [
          // 1. DYNAMIC SYSTEM BOOKMARK BUTTON
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            color: isSaved ? Colors.amber : null,
            onPressed: () async {
              bool status = await BookmarkShareHelper.toggleBookmark(widget.title, widget.description);
              if (mounted) {
                setState(() {
                  isSaved = status;
                });
              }
            },
          ),
          // 2. NATIVE PLATFORM CONTAINER SHARE BUTTON
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
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.date,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}