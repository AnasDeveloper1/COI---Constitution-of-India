
import 'package:constitutionofindia/screen_articles/article_detail_screen.dart';
import 'package:constitutionofindia/services/api_services.dart';
import 'package:flutter/material.dart';


class ArticlesScreen extends StatefulWidget {
  final String partId;
  final String title;

  const ArticlesScreen({
    super.key,
    required this.partId,
    required this.title,
  });

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;

  List articles = [];

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  Future<void> getArticles() async {
    try {
      final data = await apiService.getData(
        "https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_articles?part_id=${widget.partId}",
      );

      setState(() {
        if (data is List && data.isNotEmpty && data.first is String) {
          articles = [];
        } else {
          articles = data;
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        articles = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : articles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "No Articles Available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                            title: Text(
                              article["title"] ?? "No Title",
                            ),
                            subtitle: Text(
                              article["small_description"] ?? "No Description",
                            ),
                            // ADD THIS ONTAP BLOCK TO ENABLE CLICKING:
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailsScreen(
                                    title: article["title"] ?? "No Title",
                                    description: article["description"] ??
                                        article["small_description"] ??
                                        "No Description",
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  ));
  }
}
