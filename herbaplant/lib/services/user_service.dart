import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 
  "https://herbaplant-backend-2-0-1t87.onrender.com/user";
  //"http://192.168.254.196:5000/user"; //local testing

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

  //* Get chat / generated image history
    static Future<List<Map<String, dynamic>>> getChatHistory() async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      // Use the /prompt/get-chat-history endpoint
      final url = Uri.parse(
        //"http://192.168.254.196:5000/prompt/get-chat-history"
        "https://herbaplant-backend-2-0-1t87.onrender.com/prompt/get-chat-history"
        );

      try {
        final response = await http.get(url, headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        });

        if (response.statusCode == 400) return [{}];
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        return [
          {"error": "Error in getChatHistory: $e"}
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
