import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ArticleService {
  
  static const String gNewsApiKey = "c5169b26e80899bdb2210234b8ed11f1";

  static Future<List<dynamic>> fetchTrendingNews() async {
    final url = Uri.parse(
        "https://gnews.io/api/v4/top-headlines?country=ph&category=health&apikey=$gNewsApiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["articles"] ?? [];
      } else {
        print(" Failed to fetch news: ${response.body}");
        return [];
      }
    } catch (e) {
      print(" Network error: $e");
      return [];
    }
  }

}
