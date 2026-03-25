import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/screens/splash_screen.dart';
import 'package:trackweaving/utils/app_strings.dart';
import 'package:trackweaving/utils/internationalization.dart';
import 'package:trackweaving/utils/my_theme_controller.dart';

import 'utils/get_di.dart' as getit;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if it hasn't been already (important for background tasks)
  await Firebase.initializeApp();

  // You can perform heavy data fetching or local processing here.
  log("Handling a background message: ${message.messageId}");
  log("Notification Title: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Register the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await getit.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,
      theme: themeController.lightTheme,
      darkTheme: themeController.lightTheme,
      translations: AppTranslations(), // translations
      //locale: Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale('en', 'US'),
      home: SplashScreen(),
      //
    );
  }
}
