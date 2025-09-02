import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  //static const String baseUrl = "http://127.0.0.1:5000/user"; //uncomment for local
  static const String baseUrl = "http://192.168.68.106:5000/user";
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

  //* Delete history
  static Future<bool> deleteHistoryItems(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/delete-history");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"ids": ids}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Delete failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting history: $e");
      return false;
    }
  }

  // Upload profile picture
  static Future<Map<String, dynamic>> updateProfilePicture(
      File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/update-profile-picture");

    try {
      var request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $token";
      request.files
          .add(await http.MultipartFile.fromPath("image", imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Error uploading image: $e"};
    }
  }
}
