import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/models/notifications_list_response.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/login_repo.dart';
import 'package:trackweaving/repository/notifications_repo.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/screens/home/home_screen.dart';

//old controller
class NotificationController extends GetxController implements GetxService {
  RxBool isLoading = false.obs;
  RxList<NotificationModel> notificationsList = RxList();

  final lastAction = 'Awaiting events...'.obs;

  RxInt currentPage = 1.obs; // Start at page 1
  RxBool hasNextPage = true.obs; // Flag to stop loading when no more data
  RxBool isPaginating = false.obs;

  LoginRepo loginRepo = Get.find<LoginRepo>();
  NotificationsRepo notificationsRepo = Get.find<NotificationsRepo>();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'general_notifications',
    'General',
    enableVibration: true,
    importance: Importance.high,
    playSound: true,
    description: 'Used for general notifications',
  );

  static const _alertChannel = AndroidNotificationChannel(
    'alert_notifications',
    'Alerts',
    enableVibration: true,
    importance: Importance.max,
    description: 'Used for alert notifications',
    playSound: true,
    sound: RawResourceAndroidNotificationSound('siren'),
  );

  Future<void> initializeNotifications() async {
    await _initLocalNotifications();
  }

  // --- 1. LOCAL NOTIFICATION SETUP (For Foreground Messages) ---
  Future<void> _initLocalNotifications() async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleMessageAction(response.payload);
      },
    );

    // dart format off
    final impl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await impl?.createNotificationChannel(_channel);
    await impl?.createNotificationChannel(_alertChannel);
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    await _setupInteractions();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(jsonEncode(message.toMap()));
      _showForegroundNotification(message);
    });
    // dart format on
  }

  // --- 3. MESSAGE HANDLING LOGIC ---

  /// Handles the actual redirection/action when a notification is tapped.
  void _handleMessageAction(String? payload) {
    if (payload != null) {
      // In a real app, you would navigate to a specific screen based on the payload.
      // E.g., Get.toNamed(payload);

      lastAction.value = 'Tapped on notification with payload: $payload';

      Get.to(() => HomeScreen(), arguments: {'navigateToNotifications': true});
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().changeNavIndex(
          2,
        ); // Navigate to Notifications tab
      } else {
        log(
          'HomeController not registered. Cannot navigate to Notifications tab.',
        );
        Get.put(HomeController()).changeNavIndex(2);
      }
      // Navigate to Notifications tab
    }
  }

  /// Handles messages when the app is in the **TERMINATED** or **BACKGROUND** state
  Future<void> _setupInteractions() async {
    // Get any message which caused the application to open from a terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      lastAction.value = 'App opened from terminated state.';
      _handleMessageAction(initialMessage.data['route']);
    }

    // Stream listener when the application is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(jsonEncode(message.data));
      lastAction.value = 'App opened from background state.';
      _handleMessageAction(message.data['route']);
    });
  }

  /// Handles messages when the app is in the **FOREGROUND** state

  void _showForegroundNotification(
    RemoteMessage message, {
    String? source,
  }) async {
    log('_showForegroundNotification called from $source');
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];
    if (title == null) return;
    final sound = message.data['sound'] ?? 'default';
    final isCritical = sound == 'siren.caf';
    final channel = isCritical ? _alertChannel : _channel;
    _plugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: channel.importance,
          channelDescription: channel.description,
          playSound: true,
          sound: channel.sound,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: message.data['sound'] ?? 'default',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  //----- notification list -----
  Future<void> getNotifications({bool isRefresh = false}) async {
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
        if (!isRefresh) currentPage.value--;
      } else {
        notificationsList.addAll(data);
      }

      //notificationsList.value = data;
      Future.delayed(const Duration(seconds: 2), () {
        markAsRead();
      });

      // log('Fetched notifications: $data');
    } on ApiException catch (e) {
      log('Error fetching notifications: $e');
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

  Future<void> markAsRead() async {
    List<String> notificationIds = [];
    for (var element in notificationsList) {
      if (!element.isRead) {
        notificationIds.add(element.id);
      }
    }
    log('Marking notifications as read: ${notificationIds.length}');

    if (notificationIds.isEmpty) {
      //when list is empty then no need to call api
      return;
    }
    try {
      isLoading.value = true;
      var success = await notificationsRepo.markAsRead(notificationIds);
      if (success) {
        log('Notifications marked as read successfully.');
      }
    } on ApiException catch (e) {
      log('Error marking notifications as read: $e');
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
