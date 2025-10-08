import 'dart:developer';

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/models/notifications_list_response.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/login_repo.dart';
import 'package:trackweaving/repository/notifications_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/home/home_screen.dart';

class NotificationController extends GetxController implements GetxService {
  RxBool isLoading = false.obs;
  RxList<NotificationModel> notificationsList = RxList();
  final fcmToken = ''.obs;

  final lastNotificationAction = 'Awaiting events...'.obs;

  RxInt currentPage = 1.obs; // Start at page 1
  RxBool hasNextPage = true.obs; // Flag to stop loading when no more data
  RxBool isPaginating = false.obs;

  LoginRepo loginRepo = Get.find<LoginRepo>();
  NotificationsRepo notificationsRepo = Get.find<NotificationsRepo>();

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
      Get.find<HomeController>().changeNavIndex(
        2,
      ); // Navigate to Notifications tab
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

  //----- notification list -----
  getNotifications({bool isRefresh = false}) async {
    if (!hasNextPage.value && !isRefresh) {
      log('No more pages to load.', name: 'NotificationsController');
      return;
    }

    // Determine the loading state flag
    if (isRefresh) {
      isLoading.value = true; // Use primary loader for initial/refresh
      currentPage.value = 1;
      notificationsList.value = [];
      hasNextPage.value = true;
    } else {
      isPaginating.value = true; // Use secondary loader for subsequent pages
      currentPage.value++;
    }

    try {
      isLoading.value = true;
      var data = await notificationsRepo.getNotifications(
        page: currentPage.value,
      );

      if (data.isEmpty) {
        hasNextPage.value = false; // Stop further calls
        // Decrement page if nothing was loaded to stay on the last valid page
        if (!isRefresh) currentPage.value--;
      } else {
        notificationsList.addAll(data);
      }

      //notificationsList.value = data;
      Future.delayed(const Duration(seconds: 2), () {
        markAsRead();
      });

      // print('Fetched notifications: $data');
    } on ApiException catch (e) {
      print('Error fetching notifications: $e');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      if (isRefresh) {
        isLoading.value = false;
      } else {
        isPaginating.value = false;
      }
    }
  }

  markAsRead() async {
    List<String> notificationIds = [];
    for (var element in notificationsList) {
      if (!element.isRead) {
        notificationIds.add(element.id);
      }
    }
    print('Marking notifications as read: $notificationIds');
    for (var element in notificationIds) {
      print('Marking notification as read: $element');
    }
    if (notificationIds.isEmpty) {
      //when list is empty then no need to call api
      return;
    }
    try {
      isLoading.value = true;
      var success = await notificationsRepo.markAsRead(notificationIds);
      if (success) {
        // Update local list to reflect changes
        // for (var id in notificationIds) {
        //   int index = notificationsList.indexWhere(
        //     (notification) => notification.id == id,
        //   );
        //   if (index != -1) {
        //     notificationsList[index].isRead = true;
        //   }
        // }
        // notificationsList.refresh();
      }
    } on ApiException catch (e) {
      print('Error marking notifications as read: $e');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }
}
