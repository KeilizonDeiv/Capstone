import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PromptService {
  static const String baseUrl = "http://127.0.0.1:5000/prompt";

  //! Untested Code

  //* Handle gemini queries
  static Future<Map<String, dynamic>> handlePrompt(
      String prompt, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/query");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content Type'] = 'multi/form-data';
    request.fields['prompt'] = prompt;

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 400) {
        return {
          "error": "Error in handlePrompt, Server Response: $responseBody"
        };
      }

      return jsonDecode(responseBody);
    } catch (e) {
      return {"error": "Error in handlePrompt"};
    }
  }
}
