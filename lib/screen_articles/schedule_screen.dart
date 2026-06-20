import 'package:constitutionofindia/services/api_services.dart';
import 'package:flutter/material.dart';
import '../screens/bookmark_share_helper.dart'; // Import your storage helper here

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  List schedules = [];

  @override
  void initState() {
    super.initState();
    getSchedules();
  }

  Future<void> getSchedules() async {
    final data = await apiService.getData(
      "https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_schedule",
    );

    setState(() {
      schedules = data;
      isLoading = false;
    });
  }

  void openScheduleDetails(Map schedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleDetailScreen(
          title: schedule["title"] ?? "",
          description: schedule["small_description"] ?? "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Constitution Schedules",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => openScheduleDetails(schedule),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: Text(
                        schedule["id"] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        schedule["title"] ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

// --- UPGRADED STATEFUL DETAIL VIEW COMPONENT ---
class ScheduleDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const ScheduleDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    // Check background storage memory when the detail view loads up on screen
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
          // 1. WORKING BOOKMARK BUTTON
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
          // 2. WORKING NATIVE SHARE BUTTON
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
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}