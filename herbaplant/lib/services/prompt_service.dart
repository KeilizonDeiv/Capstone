import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//! Untested Code

class PromptService {
  static const String baseUrl = "http://192.168.254.172:5000/prompt"; //uncomment for non local
  // static const String baseUrl = "http://127.0.0.1:5000/prompt"; //uncomment for local

  //* Handle gemini queries
  static Future<Map<String, dynamic>> handlePrompt(
      String prompt, XFile? imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/query");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['prompt'] = prompt;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        return {
          "error": "Error in handlePrompt, Server Response: $responseBody"
        };
      }

      return jsonDecode(responseBody);
    } catch (e) {
      return {"error": "Error in handlePrompt"};
    }
  }

  static Future<Map<String, dynamic>> chatPrompt(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/chat");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode >= 400) {
      return {"error": response.body};
    }

    return jsonDecode(response.body);
  }


}
