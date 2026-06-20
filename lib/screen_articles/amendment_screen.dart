import 'dart:convert';

import 'package:constitutionofindia/screen_articles/amendmentdetailscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AmendmentScreen extends StatefulWidget {
  const AmendmentScreen({super.key});

  @override
  State<AmendmentScreen> createState() => _AmendmentScreenState();
}

class _AmendmentScreenState extends State<AmendmentScreen> {
  List amendments = [];
  List filteredAmendments = [];

  bool isLoading = true;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchAmendments();
  }

  Future<void> fetchAmendments() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_amendments',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          amendments = data;
          filteredAmendments = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchAmendments(String value) {
    setState(() {
      searchText = value;

      filteredAmendments = amendments.where((item) {
        return item['title']
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> refreshData() async {
    await fetchAmendments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Constitution Amendments"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchAmendments,
                    decoration: InputDecoration(
                      hintText: "Search Amendment...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshData,
                    child: ListView.builder(
                      itemCount: filteredAmendments.length,
                      itemBuilder: (context, index) {
                        final amendment = filteredAmendments[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                amendment['id'],
                              ),
                            ),
                            title: Text(
                              amendment['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              amendment['small_description']
                                  .toString()
                                  .replaceAll('\n', ' ')
                                  .replaceAll('\r', ' '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AmendmentDetailScreen(
                                    title: amendment['title'],
                                    description: amendment['small_description'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
