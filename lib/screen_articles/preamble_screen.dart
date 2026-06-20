import 'package:constitutionofindia/services/api_services.dart';
import 'package:flutter/material.dart';


class PreambleScreen extends StatefulWidget {
  const PreambleScreen({super.key});

  @override
  State<PreambleScreen> createState() => _PreambleScreenState();
}

class _PreambleScreenState extends State<PreambleScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;

  dynamic preambleData;

  @override
  void initState() {
    super.initState();
    getPreamble();
  }

  Future<void> getPreamble() async {
    final data = await apiService.getData(
      "https://mapi.trycatchtech.com/v3/constitution_of_india/constitution_of_india_preamble",
    );

    setState(() {
      preambleData = data[0];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preamble",
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
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      preambleData["image"],
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            preambleData["title"],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          preambleData["description"],
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
