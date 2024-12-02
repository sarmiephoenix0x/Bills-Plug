import 'package:bills_plug/intro_page.dart';
import 'package:bills_plug/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

// Initialize the local notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  // Dynamically set the channel ID and channel name
  String channelId = "dynamic_channel_${DateTime.now().millisecondsSinceEpoch}";
  String channelName = "Dynamic Notification Channel ${DateTime.now()}";

  // Create the notification channel dynamically
  await _createNotificationChannel(channelId, channelName);

  // Show the notification in the background
  _showNotification(message, channelId, channelName);
}

Future<void> _createNotificationChannel(
    String channelId, String channelName) async {
  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'default_channel', // Default channel for creating fallback
    'Default Channel', // Fallback name
    description: 'This is the default notification channel',
    importance: Importance.high,
  );

  // Ensure the channel is created before showing notifications
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

Future<void> _showNotification(
    RemoteMessage message, String channelId, String channelName) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'default_channel', // Fallback channel
    'Fallback Channel',
    importance: Importance.max,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize local notifications plugin
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a foreground message: ${message.notification?.title}');

    // Dynamically set the channel ID and name
    String channelId =
        "dynamic_channel_${DateTime.now().millisecondsSinceEpoch}";
    String channelName = "Dynamic Notification Channel ${DateTime.now()}";

    // Show notification for foreground message
    _showNotification(message, channelId, channelName);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check network connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Handle no network case
      print('No network connection');
      setState(() {
        isLoading = false; // Stop loading
      });
      // Optionally, show a message or a retry button
      return;
    }

    // Proceed with fetching the token and checking login status
    await _requestPermission();
    await _getToken();

    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'billsplug_accessToken');
    isLoggedIn = accessToken != null;

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined permission');
    }
  }

  Future<void> _getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      print("FCM Token: $token");

      if (token != null) {
        // Save the token locally for later use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', token);
      }
    } catch (e) {
      print("Error fetching token: $e");
    }
  }

  Future<String?> getStoredFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken');
  }

  Future<void> sendTokenToServer(String? token) async {
    if (token == null) return;

    final response = await http.post(
      Uri.parse(
          'https://86t6buc6j0.execute-api.eu-north-1.amazonaws.com/test/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
      }),
    );

    if (response.statusCode == 200) {
      print('Token sent to server successfully');
    } else {
      print('Failed to send token to server: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF02AA03))), // Loading indicator
        ),
      );
    }

    return MaterialApp(
      home: isLoggedIn ? const MainApp() : const IntroPage(),
    );
  }
}
