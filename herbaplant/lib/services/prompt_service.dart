import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PromptService {
  static const String baseUrl = 
  "https://herbaplant-backend-2-0-1t87.onrender.com/prompt";
  //"http://192.168.254.196:5000/prompt"; //local testing

  /// Handles prompt + optional image upload
  static Future<Map<String, dynamic>> handlePrompt(
      String prompt, dynamic imageInput) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/query");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['prompt'] = prompt;

    // Normalize input to a File
    File? file;
    if (imageInput is XFile) {
      file = File(imageInput.path);
    } else if (imageInput is File) {
      file = imageInput;
    }

    // Only add file if it exists and has bytes
    if (file != null && await file.exists()) {
      final bytes = await file.readAsBytes();
      if (bytes.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: path.basename(file.path),
        ));
      } else {
        return {"error": "Selected file is empty or invalid"};
      }
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 400) {
        return {
          "error": "Error in handlePrompt, Server Response: $responseBody"
        };
      }

      return jsonDecode(responseBody);
    } catch (e) {
      return {"error": "Error in handlePrompt: $e"};
    }
  }

  /// Chat-only prompt, no image
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
