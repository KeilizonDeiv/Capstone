import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


const List<String> scopes = <String>[
  'email',
  'profile',
  'openid',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class AuthService {
  static const String baseUrl =
      "https://herbaplant-backend-2-0-1t87.onrender.com/auth"; //uncomment for non local
      //"http://192.168.254.196:5000/auth"; //local testing

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
    serverClientId:
        "246870897993-l33inr0agc8jvt06p0gcbvs0dhqjc402.apps.googleusercontent.com",
  );

  //* Login
  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  //* Google Signin
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    final url = Uri.parse("$baseUrl/google_login");

    try {
      // Force sign-out so user can re-select an account
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {"error": "Google sign-in canceled"};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        return {"error": "Google returned a null idToken"};
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_token": idToken}),
      );

      if (response.statusCode != 200) {
        return {
          "error":
              "Backend rejected token (${response.statusCode}): ${response.body}"
        };
      }

      return jsonDecode(response.body);
    } catch (e, stack) {
      print("❌ Google sign-in failed: $e");
      print(stack);
      return {"error": "Google sign-in failed: $e"};
    }
}


  //* Register
  static Future<Map<String, dynamic>?> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
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
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }));

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> resetPassword(
      String token, String newPassword, String confirmPassword) async {
    final url = Uri.parse("$baseUrl/reset-password?token=$token");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      }),
    );

    return jsonDecode(response.body);
  }


  //* Log in as Guest
  static Future<Map<String, dynamic>?> loginAsGuest() async {
    final url = Uri.parse("$baseUrl/guest");

    final response =
        await http.post(url, headers: {"Content-Type": "application/json"});

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
          "Content-Type": "application/json",
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
  static Future<Map<String, dynamic>> updateFirstTimeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/update-first-time-login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
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
          "Content-Type": "application/json",
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

  //! [!] End

  //* Change Password
  static Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/change-password");

    try {
      print("➡️ Sending change-password request to $url");
      print("   Headers: Authorization Bearer $token");
      print("   Body: old=$oldPassword new=$newPassword");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password": newPassword,
        }),
      );

      print("⬅️ Response ${response.statusCode}: ${response.body}");

      return jsonDecode(response.body);
    } catch (e, stack) {
      print("❌ changePassword failed: $e");
      print(stack);
      return {"error": "Request failed: $e"};
    }
  }

  //* Get user info
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse("$baseUrl/user-info");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 400) return jsonDecode(response.body);

    return jsonDecode(response.body);
  }
}
