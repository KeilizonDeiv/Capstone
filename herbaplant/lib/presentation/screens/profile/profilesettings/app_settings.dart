import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static const String themeKey = "darkMode";
  static const String languageKey = "language";

  bool _isDarkMode = false;
  String _language = "English";

  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  AppSettings() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(themeKey) ?? false;
    _language = prefs.getString(languageKey) ?? "English";
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, value);
  }

  Future<void> changeLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, lang);
  }
}
