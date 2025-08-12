import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//! Untested Code
class UserService {
  static const String baseUrl = "http://127.0.0.1:5000/user";

  //* Get User History
  static Future<List<Map<String, dynamic>>> getUserHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/get-history");

    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 400) return [{}];

      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> history =
          List<Map<String, dynamic>>.from(data);
      return history;
    } catch (e) {
      return [
        {"error": "Error in getUserHistory"}
      ];
    }
  }

  //* Get image history
  static Future<List<Map<String, dynamic>>> getImageHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/get-image-history");

    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });

      if (response.statusCode == 400) return [{}];

      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> imgHistory =
          List<Map<String, dynamic>>.from(data);
      return imgHistory;
    } catch (e) {
      return [
        {"error": "Error in getImageHistoryS"}
      ];
    }
  }
}
