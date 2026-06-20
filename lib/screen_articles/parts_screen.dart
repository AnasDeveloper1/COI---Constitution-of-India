import 'package:constitutionofindia/services/api_services.dart';
import 'package:flutter/material.dart';

import 'articles_screen.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;

  List parts = [];

  @override
  void initState() {
    super.initState();
    getParts();
  }

  Future<void> getParts() async {
    final data = await apiService.getData(
      "https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_parts",
    );

    setState(() {
      parts = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get active theme references
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Constitution Parts",
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
              itemCount: parts.length,
              itemBuilder: (context, index) {
                final part = parts[index];

                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: Card(
                    elevation: 4,
                    // FIXED: Dynamic surface color background adaptation
                    color: isDark ? theme.colorScheme.surfaceContainerLow : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticlesScreen(
                              partId: part["id"],
                              title: part["title"],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                
                              backgroundColor: isDark 
                                  ? theme.colorScheme.primaryContainer 
                                  : const Color(0xffEFF6FF),
                              child: Text(
                                part["id"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  // Flips the numbers cleanly between deep blue or light theme primary colors
                                  color: isDark 
                                      ? theme.colorScheme.onPrimaryContainer 
                                      : const Color(0xff1E3A8A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 2. FIXED MAIN TITLE TEXT
                                  Text(
                                    part["title"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface, 
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // 3. FIXED SMALL DESCRIPTION TEXT
                                  Text(
                                    part["small_description"],
                                    style: TextStyle(
                                      // Softens the description text look natively on both modes
                                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 4. FIXED ACTION ARROW ICON
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}