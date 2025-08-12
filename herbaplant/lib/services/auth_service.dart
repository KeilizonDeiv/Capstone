import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//! Code here is untested
// TODO: Implement better debugging for exception returns, also maybe use toasts to display errors?

class AuthService {
  static const String baseUrl = "http://127.0.0.1:5000/auth";

  //* Login
  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  //* Register
  static Future<Map<String, dynamic>?> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(url,
        headers: {"Content Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }));

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  //* Forgot Password
  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    final url = Uri.parse("$baseUrl/forgot-password");

    final response = await http.post(url,
        headers: {"Content Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  //* Log in as Guest
  static Future<Map<String, dynamic>?> loginAsGuest() async {
    final url = Uri.parse("$baseUrl/guest");

    final response =
        await http.post(url, headers: {"Content Type": "application/json"});

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  // Logout

  //* Check verification status
  static Future<bool> checkVerificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/check-verification/status");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 400) return false;

      final data = jsonDecode(response.body);

      return data["verified"] ?? false;
    } catch (e) {
      print("Error in verification");
      return false;
    }
  }

  //* Update First time login
  static Future<Map<String, dynamic?>> updateFirstTimeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/update-first-time-login");

    final response = await http.get(
      url,
      headers: {
        "Content Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 400) return jsonDecode(response.body);
    return jsonDecode(response.body);
  }

  //* Update User
  static Future<bool> updateUser(String field, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/update-user");

    final response = await http.put(url,
        headers: {
          "Content Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({field: newValue}));

    if (response.statusCode == 400) {
      print("Failed to update user info");
      return false;
    }

    // TODO: Add force logout logic here if email is updated

    return true;
  }
}
