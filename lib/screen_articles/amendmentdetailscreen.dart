// lib/screen_articles/amendmentdetailscreen.dart
import 'package:flutter/material.dart';

import '../screens/bookmark_share_helper.dart';


class AmendmentDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const AmendmentDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<AmendmentDetailScreen> createState() => _AmendmentDetailScreenState();
}

class _AmendmentDetailScreenState extends State<AmendmentDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            color: isSaved ? Colors.amber : null,
            onPressed: () async {
              // CRITICAL: Passing both widget.title AND widget.description down to the database helper
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
        child: SelectableText(
          widget.description,
          style: const TextStyle(fontSize: 16, height: 1.7),
        ),
      ),
    );
  }
}