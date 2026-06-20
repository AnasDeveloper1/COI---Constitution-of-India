import 'package:constitutionofindia/services/api_services.dart';
import 'package:flutter/material.dart';
import '../screens/bookmark_share_helper.dart'; // Import your storage helper here

class CaseStudyScreen extends StatefulWidget {
  const CaseStudyScreen({super.key});

  @override
  State<CaseStudyScreen> createState() => _CaseStudyScreenState();
}

class _CaseStudyScreenState extends State<CaseStudyScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  List caseStudies = [];

  @override
  void initState() {
    super.initState();
    getCaseStudies();
  }

  Future<void> getCaseStudies() async {
    try {
      final data = await apiService.getData(
        "https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_case_study",
      );

      setState(() {
        caseStudies = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Case Studies",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: caseStudies.length,
        itemBuilder: (context, index) {
          final caseStudy = caseStudies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CaseStudyDetailScreen(
                      title: caseStudy["title"] ?? "No Title",
                      // FIXED: Using "small_description" to match your exact API data fields
                      description: caseStudy["small_description"] ?? "No Description",
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseStudy["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to read full case study",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- FIXED STATEFUL DETAIL VIEW COMPONENT ---
class CaseStudyDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const CaseStudyDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<CaseStudyDetailScreen> createState() => _CaseStudyDetailScreenState();
}

class _CaseStudyDetailScreenState extends State<CaseStudyDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    // Checks database memory when opening this case study to see if it's already bookmarked
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
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // 1. WORKING SYSTEM BOOKMARK BUTTON
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
          // 2. WORKING SYSTEM NATIVE SHARE BUTTON
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
          style: const TextStyle(
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ),
    );
  }
}