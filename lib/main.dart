import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/controllers/localization_controller.dart';
import 'package:trackweaving/controllers/notifications_controller.dart';
import 'package:trackweaving/screens/splash_screen.dart';
import 'package:trackweaving/utils/app_strings.dart';
import 'package:trackweaving/utils/internationalization.dart';
import 'package:trackweaving/utils/my_theme_controller.dart';
import 'package:get/get.dart';
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

  final LocalizationController localizationController = Get.find();

  final NotificationController controller = Get.find<NotificationController>();
  final HomeController? homeController = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : null;

  @override
  void initState() {
    super.initState();
    controller.initializeNotifications();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNotificationNavigation();
    });
  }

  void _handleInitialNotificationNavigation() {
    controller.shouldNavigateToNotificationsTab().then((shouldNavigate) {
      if (shouldNavigate && homeController != null) {
        homeController!.changeNavIndex(2); // Assuming index 2 is Notifications
      }
    });
  }

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
