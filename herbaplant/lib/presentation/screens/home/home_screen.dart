import 'package:flutter/material.dart';
import 'package:herbaplant/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // 👈 add this

import '../../../core/constants/app_colors.dart';
import 'widgets/get_started_steps.dart';
import '../profile/profile_screen.dart';
import 'widgets/notification_service.dart';
import 'package:herbaplant/services/article_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  List<dynamic> trendingNews = [];

  // 👇 Keys for tutorial targets
  final GlobalKey _getStartedKey = GlobalKey();
  final GlobalKey _newsKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _initUser();
    _fetchTrendingNews();
    _sendNotificationOnce();
  }

  Future<void> _initUser() async {
    await _getUserData();
    await _loadUserFromStorage();
  }

  void _updateFirstTimeLogin() async {
    try {
      await AuthService.updateFirstTimeLogin();
    } catch (e) {
      debugPrint("Error updating first_time_login: $e");
    }
  }

  Future<void> _getUserData() async {
    try {
      final userData = await AuthService.getUserInfo();
      final prefs = await SharedPreferences.getInstance();

      // Save user info
      await prefs.setInt("id", userData["id"]);
      await prefs.setString("username", userData["username"]);
      await prefs.setString("email", userData["email"]);
      await prefs.setBool("verified", userData["verified"]);
      await prefs.setBool("first_time_login", userData["first_time_login"]);

      if (userData["profile_image"] != null) {
        await prefs.setString("profile_image", userData["profile_image"]);
      }

      // 👇 Only show tutorial if first_time_login == true
      if (userData["first_time_login"] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showTutorial();
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> _loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("username") ?? "User";
    });
  }

  void _fetchTrendingNews() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = Uri.parse(
         "https://herbaplant-backend-2-0-1t87.onrender.com/articles/trending-news");
        //"http://192.168.254.196:5000/articles/trending-news"); //local testing
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> news = jsonDecode(response.body);
      if (news.isNotEmpty &&
          (trendingNews.isEmpty ||
              news.first["title"] != trendingNews.first["title"])) {
        NotificationService.showNotification(
          "New Trending News!",
          news.first["title"],
        );
      }

      setState(() {
        trendingNews = news;
      });
    } else {
      print("⚠️ Failed to fetch news: ${response.body}");
    }
  }

  void _sendNotificationOnce() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasNotified = prefs.getBool('has_notified') ?? false;

    if (!hasNotified) {
      await NotificationService.showNotification(
          "Welcome!", "You have entered Home User.");
      await prefs.setBool('has_notified', true);
    }
  }

  // 👇 Tutorial function
  void _showTutorial() {
    final targets = [
      TargetFocus(
        identify: "GetStarted",
        keyTarget: _getStartedKey,
        shape: ShapeLightFocus.RRect,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Here are your Get Started steps.\nFollow these to explore the app!",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "News",
        keyTarget: _newsKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Text(
              "Check out the latest trending news about herbal plants here.",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ];

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      // textSkip: "SKIP",
      hideSkip: false,
      onFinish: () {
        debugPrint("✅ Tutorial finished");
        _updateFirstTimeLogin();
      },
      onSkip: () {
        debugPrint("⏭ Tutorial skipped");
        _updateFirstTimeLogin();
        return true; // required for your version
      },
    );

    tutorialCoachMark.show(context: context);
  }

  void _openNewsArticle(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("❌ Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppColors.backgroundwh,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C553B),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        title: Text(
          "Hi, $userName",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👇 Attach tutorial key
              GetStartedSteps(key: _getStartedKey),

              // Section header with tutorial key
              // 👇 Wrap the entire news section with the key
              Column(
                key: _newsKey, // 👈 attach key here instead of just the header
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.question_mark_outlined,
                            color: Color(0xFF0C553B)),
                        const SizedBox(width: 8),
                        Text(
                          'What\'s New?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Trending news cards
                  SizedBox(
                    height: 250,
                    child: trendingNews.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(16.0),
                            itemCount: trendingNews.length > 3
                                ? 3
                                : trendingNews.length,
                            itemBuilder: (context, index) {
                              final article = trendingNews[index];
                              return GestureDetector(
                                onTap: () => _openNewsArticle(article["url"]),
                                child: Container(
                                  width: 250,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[900]
                                        : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Image
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            article["image"] ??
                                                "https://via.placeholder.com/250",
                                            width: 250,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 250,
                                                height: 150,
                                                color: isDark
                                                    ? Colors.grey[800]
                                                    : Colors.grey[300],
                                                child: const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.broken_image,
                                                          color: Colors.red,
                                                          size: 40),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        "Image failed to load",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Title
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          article["title"] ?? "No Title",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Description
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          article["description"] ??
                                              "No description available",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
