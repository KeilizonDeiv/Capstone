import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Request permission for Android 13+
    await requestPermission();
  }

  static Future<void> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  static Future<void> showNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    bool isNotificationEnabled = prefs.getBool('push_notifications') ?? true;

    if (!isNotificationEnabled) {
      return; // Exit early if notifications are disabled
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Unique ID for your channel
      'channel_name',
      channelDescription: 'Your notification channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
