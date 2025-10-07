import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trackweaving/repository/login_repo.dart';
import 'package:trackweaving/screens/home/home_screen.dart';

class NotificationController extends GetxController implements GetxService {
  final fcmToken = ''.obs;

  final lastNotificationAction = 'Awaiting events...'.obs;

  LoginRepo loginRepo = Get.find<LoginRepo>();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> initializeNotifications() async {
    await _initLocalNotifications();
    await _requestPermission();
    await _setupInteractions();
    _handleForegroundMessages();
    getFCMToken();
  }

  // --- 1. LOCAL NOTIFICATION SETUP (For Foreground Messages) ---

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap when the app is in the foreground/background
        _handleMessageAction(response.payload);
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // IMPORTANT: Allow heads-up notifications when the app is in the foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      fcmToken.value = token;
      print("FCM Token: $token");
      loginRepo.saveFcmToken(token); // Save token using LoginRepo
    }

    // Listen for token changes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      print("FCM Token Refreshed: $newToken");
      loginRepo.saveFcmToken(newToken);
    });
  }

  // --- 3. MESSAGE HANDLING LOGIC ---

  /// Handles the actual redirection/action when a notification is tapped.
  void _handleMessageAction(String? payload) {
    if (payload != null) {
      // In a real app, you would navigate to a specific screen based on the payload.
      // E.g., Get.toNamed(payload);

      lastNotificationAction.value =
          'Tapped on notification with payload: $payload';
      Get.snackbar(
        "Notification Tapped!",
        "Handling action for payload: $payload",
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(() => HomeScreen(), arguments: {'navigateToNotifications': true});
    }
  }

  // --- 4. APP STATE LISTENERS ---

  /// Handles messages when the app is in the **TERMINATED** or **BACKGROUND** state
  Future<void> _setupInteractions() async {
    // 1. Get any message which caused the application to open from a terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      lastNotificationAction.value = 'App opened from terminated state.';
      _handleMessageAction(initialMessage.data['route']);
    }

    // 2. Stream listener when the application is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      lastNotificationAction.value = 'App opened from background state.';
      _handleMessageAction(message.data['route']);
    });
  }

  /// Handles messages when the app is in the **FOREGROUND** state
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      lastNotificationAction.value = 'Received FOREGROUND message.';

      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      // Use local notifications to display the heads-up notification in the foreground
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode, // Unique ID
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id, // Must match the channel ID defined above
              _channel.name,
              channelDescription: _channel.description,
              icon: android.smallIcon,
            ),
          ),
          // Pass any custom data to the payload so it can be handled on tap
          payload: message.data['route'] ?? 'default_route',
        );
      }
    });
  }

  // In your NotificationController class:

  Future<bool> shouldNavigateToNotificationsTab() async {
    // Check for message received while the app was terminated
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      return true;
    }
    return false;
  }
}
