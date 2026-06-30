import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'weather_service.dart';
import 'api_service.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final WeatherService _weatherService = WeatherService();
  final ApiService _apiService = ApiService();

  Future<void> init() async {
    // 1. Local Notifications Init
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // 2. Firebase Messaging Init
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions (FCM)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');

      // Get the token and save it to our backend
      String? token = await messaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _apiService.saveDeviceToken(token);
      }
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null) {
        _showPushNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showPushNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'push_notifications',
      'Push Notifications',
      channelDescription: 'Real-time updates from NEW START Admin',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> showRandomAdvice() async {
    final double? temp = await _weatherService.getCurrentTemperature();
    final random = Random();

    String message = '';

    List<String> genericAdvice = [
      'Remember to take deep breaths of fresh air today!',
      'Practice temperance: moderation in good things and abstinence from harmful ones.',
      'A short walk after a meal aids digestion and boosts energy.',
      'Trust in divine power helps reduce stress and brings peace of mind.',
      'Make sure to get at least 8 hours of quality sleep tonight.',
      'Did you know? Sleep at 9 PM is highly beneficial for recovery.',
      'Try to finish your last meal at least 3 hours before going to bed.',
      'Get 15-30 minutes of sunlight daily for your natural Vitamin D boost.',
      'Early morning sunlight helps regulate your internal clock for better sleep.',
      'Consistency is key! Try to exercise at the same time every day.',
    ];

    if (temp != null) {
      if (temp >= 28) {
        message = 'It\'s hot out there (${temp.toStringAsFixed(1)}°C)! Increase your water consumption to stay hydrated.';
      } else if (temp <= 15) {
        message = 'It\'s a bit chilly (${temp.toStringAsFixed(1)}°C). Remember to drink your 8 glasses of water even when you don\'t feel thirsty.';
      } else {
        message = genericAdvice[random.nextInt(genericAdvice.length)];
      }
    } else {
      message = genericAdvice[random.nextInt(genericAdvice.length)];
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'new_start_advice',
      'Health Advice',
      channelDescription: 'Daily health tips from NEW START',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: random.nextInt(1000),
      title: message,
      body: '',
      notificationDetails: platformChannelSpecifics,
      payload: 'advice',
    );
  }
}
