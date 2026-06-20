import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> getData(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load data");
  }
}
