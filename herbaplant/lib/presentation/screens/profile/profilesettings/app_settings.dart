import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AppSettings extends ChangeNotifier {
  static const String themeKey = "darkMode";
  static const String languageKey = "language";

  bool _isDarkMode = false;
  String _language = "English";

  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  /// Returns the current locale for the MaterialApp
  Locale get locale {
    switch (_language) {
      case "Filipino":
        return const Locale('fil', 'PH');
      case "English":
      default:
        return const Locale('en', 'US');
    }
  }

  /// Translation map for app-wide texts
  final Map<String, Map<String, String>> _translations = {
    'English': {
      // Settings
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'currentlyDark': 'Currently: Dark',
      'currentlyLight': 'Currently: Light',
      'chooseLanguage': 'Choose Language',
      'privacyPolicy': 'Privacy Policy',
      'viewPrivacyPolicy': 'View our privacy policy',
      'language': 'Language',
      'current': 'Current',

      // Login
      'hello': 'Hello..',
      'pleaseLogin': 'Please login to continue',
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot password?',
      'orLoginWith': 'or login with',
      'continueWithGoogle': 'Continue with Google',
      'noAccount': "Don't have an account?",
      'signUp': 'Sign up',
      'loginFailed': 'Login Failed.',
      'googleLoginFailed': 'Google login failed',

      // Forgot Password
      'forgotPasswordTitle': 'Forgot Password',
      'resetYourPassword': 'Reset Your Password',
      'enterEmailToReset': 'Enter your email to receive a reset link.',
      'sendResetLink': 'Send Reset Link',
      'invalidEmail': 'Please enter a valid email',
      'resetLinkSent': 'Password reset link sent to',
      'somethingWentWrong': 'Something went wrong',

      // Register
      'createAccount': 'Create Account',
      'pleaseSignUp': 'Please sign up to continue',
      'registerTitle': 'Sign Up',
      'username': 'Username',
      'confirmPassword': 'Confirm Password',
      'registerFailed': 'Register Failed',
      'registerSuccess': 'Registration successful!',
      'passwordsDoNotMatch': 'Passwords do not match',
      'enterEmail': 'Please enter an email',
      'enterUsername': 'Please enter a username',
      'enterPassword': 'Please enter a password',
      'confirmYourPassword': 'Please confirm your password',
      'emailAlreadyExists': 'Email already exists',
      'usernameTaken': 'Username is already taken',

      // Get Started
      // ...
      'getStarted': 'Get Started',
      'step1': 'Learn how to take a clear photo for identification.',
      'step2': 'Understand how to analyze the results effectively.',
      'step3': 'Discover additional information about herbs.',
      'step4': 'Save your identification history for future reference.',
      'step5': 'Explore expert tips on herbal plant usage.',

      // Profile
      'profile': 'Profile',
      'generalSettings': 'General Settings',
      'editProfile': 'Edit Profile',
      'updateProfile': 'Update your password and profile picture',
      'promptHistory': 'History',
      'viewRecentActivities': 'View your recent activities',
      'settings': 'Settings',
      'appPreferences': 'App preferences and configurations',
      'supportInfo': 'Support & Info',
      'helpSupport': 'Help & Support',
      'getHelp': 'Get help and contact support',
      'aboutUs': 'About Us',
      'learnMore': 'Learn more about our app',
      'logOut': 'Log out',
      'logOutQuestion': 'Log out?',
      'logOutConfirmation': 'Are you sure you want to log out of your account?',
      'cancel': 'Cancel',

      // Edit Profile
      'editProfileTitle': 'Edit Profile',
      'oldPassword': 'Old Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm Password',
      'saveChanges': 'Save Changes',
      'save': 'Save',
      'cancel': 'Cancel',
      'saveChangesQuestion': 'Save Changes?',
      'updatePasswordConfirm': 'Are you sure you want to update your password?',
      'passwordUpdated': 'Password updated successfully!',
      'profilePicUpdated': 'Profile picture updated successfully!',
      'oldPasswordRequired': 'Old password is required',
      'newPasswordRequired': 'New password is required',
      'confirmPasswordRequired': 'Confirm password is required',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordTooShort': 'Password must be at least 6 characters',
      'successTitle': 'Success',

      // Prompt History
      'history': 'History',
      'selectedCount': '{count} selected',
      'deleteSelectedHistory': 'Delete Selected History?',
      'deleteConfirmation':
          'Are you sure you want to delete {count} selected item(s)?',
      'deleteSuccess': '{count} item(s) deleted.',
      'deleteFailed': '⚠️ Failed to delete history.',
      'edit': 'Edit',
      'done': 'Done',
      'delete': 'Delete',
      'noHistory': 'No History Yet',
      'yourHistoryAppearsHere': 'Your conversation history will appear here',
      'conversations': '{count} conversation(s)',
      'chatPrompt': 'Chat Prompt',
      'date': 'Date',
      'close': 'Close',

      // Help & Suport
      'frequentlyAskedQuestions': 'Frequently Asked Questions',
      'contactUs': 'Contact Us',
      'faqQuestion1': 'How do I identify a plant?',
      'faqAnswer1': "Tap the 'Identify' button and take a clear photo.",
      'faqQuestion2': 'How do I save my plant history?',
      'faqAnswer2': "Your history is saved automatically after identification.",
      'faqQuestion3': 'Can I get info about non-herbal plants?',
      'faqAnswer3': "This app focuses on herbal plants only.",

      // About us
      'version': 'Version',
      'ourMission': 'Our Mission',
      'aboutDescription':
          'HerbaPlant is a plant identification and educational app dedicated to Philippine herbal plants. We aim to empower users with knowledge about the medicinal use, growth, and care of these plants.',
      'developedBy': 'Developed by',
    },
    'Filipino': {
      // Settings
      'settings': 'Mga Setting',
      'darkMode': 'Madilim na Mode',
      'currentlyDark': 'Kasalukuyan: Madilim',
      'currentlyLight': 'Kasalukuyan: Maliwanag',
      'chooseLanguage': 'Pumili ng Wika',
      'privacyPolicy': 'Patakaran sa Pagkapribado',
      'viewPrivacyPolicy': 'Tingnan ang aming patakaran sa pagkapribado',
      'language': 'Wika',
      'current': 'Kasalukuyan',

      // Login
      'hello': 'Kamusta..',
      'pleaseLogin': 'Mangyaring mag-login upang magpatuloy',
      'login': 'Mag-login',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Nakalimutan ang password?',
      'orLoginWith': 'o mag-login gamit ang',
      'continueWithGoogle': 'Magpatuloy gamit ang Google',
      'noAccount': 'Wala pang account?',
      'signUp': 'Mag-sign up',
      'loginFailed': 'Nabigo ang pag-login.',
      'googleLoginFailed': 'Nabigo ang Google login',

      // Forgot Password
      'forgotPasswordTitle': 'Nakalimutan ang Password',
      'resetYourPassword': 'I-reset ang Iyong Password',
      'enterEmailToReset':
          'Ilagay ang iyong email upang makatanggap ng reset link.',
      'sendResetLink': 'Ipadala ang Reset Link',
      'invalidEmail': 'Mangyaring maglagay ng wastong email',
      'resetLinkSent': 'Naipadala ang password reset link sa',
      'somethingWentWrong': 'May nangyaring mali',

      // Register
      // 'createAccount': 'Gumawa ng Account',
      'pleaseSignUp': 'Mangyaring mag-sign up upang magpatuloy',
      'registerTitle': 'Mag-sign Up',
      'username': 'Username',
      'confirmPassword': 'Kumpirmahin ang Password',
      'registerFailed': 'Nabigo ang Pagrehistro',
      'registerSuccess': 'Matagumpay na nakarehistro!',
      'passwordsDoNotMatch': 'Hindi tugma ang mga password',
      'enterEmail': 'Mangyaring maglagay ng email',
      'enterUsername': 'Mangyaring maglagay ng username',
      'enterPassword': 'Mangyaring maglagay ng password',
      'confirmYourPassword': 'Mangyaring kumpirmahin ang iyong password',
      'emailAlreadyExists': 'Umiiral na ang email',
      'usernameTaken': 'Nagamit na ang username',

      //Get Started
      // ...
      'getStarted': 'Magsimula',
      'step1':
          'Alamin kung paano kumuha ng malinaw na larawan para sa pagkilala.',
      'step2': 'Unawain kung paano epektibong suriin ang mga resulta.',
      'step3':
          'Tuklasin ang karagdagang impormasyon tungkol sa mga halamang gamot.',
      'step4':
          'I-save ang iyong kasaysayan ng pagkilala para sa hinaharap na sanggunian.',
      'step5':
          'Galugarin ang mga ekspertong tip sa paggamit ng halamang gamot.',

      // Profile
      'profile': 'Profile',
      'generalSettings': 'Pangkalahatang Settings',
      'editProfile': 'I-edit ang Profile',
      'updateProfile': 'I-update ang password at profile picture mo',
      'promptHistory': 'Kasaysayan ng Prompt',
      'viewRecentActivities': 'Tingnan ang iyong mga kamakailang aktibidad',
      'settings': 'Mga Setting',
      'appPreferences': 'Mga kagustuhan at configuration ng app',
      'supportInfo': 'Suporta at Impormasyon',
      'helpSupport': 'Tulong at Suporta',
      'getHelp': 'Humingi ng tulong at makipag-ugnayan sa suporta',
      'aboutUs': 'Tungkol sa Amin',
      'learnMore': 'Alamin pa tungkol sa aming app',
      'logOut': 'Mag-log out',
      'logOutQuestion': 'Mag-log out?',
      'logOutConfirmation': 'Sigurado ka bang gusto mong mag-log out?',
      'cancel': 'Kanselahin',

      // Edit Profile
      'editProfileTitle': 'I-edit ang Profile',
      'oldPassword': 'Lumang Password',
      'newPassword': 'Bagong Password',
      'confirmPassword': 'Kumpirmahin ang Password',
      'saveChanges': 'I-save ang mga Pagbabago',
      'save': 'I-save',
      'cancel': 'Kanselahin',
      'saveChangesQuestion': 'I-save ang mga Pagbabago?',
      'updatePasswordConfirm':
          'Sigurado ka bang gusto mong i-update ang iyong password?',
      'passwordUpdated': 'Matagumpay na na-update ang password!',
      'profilePicUpdated': 'Matagumpay na na-update ang profile picture!',
      'oldPasswordRequired': 'Kinakailangan ang lumang password',
      'newPasswordRequired': 'Kinakailangan ang bagong password',
      'confirmPasswordRequired': 'Kinakailangan kumpirmahin ang password',
      'passwordsDoNotMatch': 'Hindi tugma ang mga password',
      'passwordTooShort': 'Ang password ay dapat hindi bababa sa 6 na karakter',
      'successTitle': 'Tagumpay',

      // Prompt History
      'history': 'Kasaysayan',
      'selectedCount': '{count} napili',
      'deleteSelectedHistory': 'Burahin ang Napiling Kasaysayan?',
      'deleteConfirmation':
          'Sigurado ka bang gusto mong burahin ang {count} napiling item/s?',
      'deleteSuccess': '{count} item/s nabura.',
      'deleteFailed': '⚠️ Nabigo ang pagbura ng kasaysayan.',
      'edit': 'I-edit',
      'done': 'Tapos',
      'delete': 'Burahin',
      'noHistory': 'Wala Pang Kasaysayan',
      'yourHistoryAppearsHere':
          'Lalabas dito ang iyong kasaysayan ng pag-uusap',
      'conversations': '{count} pag-uusap',
      'chatPrompt': 'Chat Prompt',
      'date': 'Petsa',
      'close': 'Isara',

      // Help & Support
      'frequentlyAskedQuestions': 'Mga Madalas Itanong',
      'contactUs': 'Makipag-ugnayan sa Amin',
      'faqQuestion1': 'Paano ako makakapag-identify ng halaman?',
      'faqAnswer1': "Pindutin ang 'Identify' at kumuha ng malinaw na larawan.",
      'faqQuestion2': 'Paano ko i-save ang aking kasaysayan ng halaman?',
      'faqAnswer2':
          "Ang iyong kasaysayan ay awtomatikong nai-save pagkatapos ng pagkilala.",
      'faqQuestion3':
          'Maaari ba akong kumuha ng impormasyon tungkol sa mga hindi halamang gamot?',
      'faqAnswer3': "Ang app na ito ay nakatuon lamang sa mga halamang gamot.",

      // About Us
      'version': 'Bersyon',
      'ourMission': 'Ang Aming Misyon',
      'aboutDescription':
          'Ang HerbaPlant ay isang app para sa pagkilala at edukasyon ng mga halamang gamot sa Pilipinas. Layunin naming bigyan ng kaalaman ang mga user tungkol sa gamot, paglaki, at pangangalaga ng mga halamang ito.',
      'developedBy': 'Binuo ng',
    },
  };

  /// Helper method to get translated text
  String t(String key) {
    return _translations[_language]?[key] ?? key;
  }

  AppSettings() {
    _load();
  }

  /// Load saved preferences from SharedPreferences
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(themeKey) ?? false;

    final savedLang = prefs.getString(languageKey);
    if (savedLang != null && _translations.containsKey(savedLang)) {
      _language = savedLang;
    } else {
      _language = "English"; // fallback
    }

    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, value);
  }

  /// Change language app-wide
  Future<void> changeLanguage(String lang) async {
    if (_translations.containsKey(lang)) {
      _language = lang;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(languageKey, lang);
    }
  }
}
