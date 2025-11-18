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

  RxInt currentPage = 1.obs; // Start at page 1
  RxBool hasNextPage = true.obs; // Flag to stop loading when no more data
  RxBool isPaginating = false.obs;

  LoginRepo loginRepo = Get.find<LoginRepo>();
  NotificationsRepo notificationsRepo = Get.find<NotificationsRepo>();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  //-- ANDROID CHANNELS (each sound = one channel) --
  static const AndroidNotificationChannel urgentChannel =
      AndroidNotificationChannel(
        'urgent_alerts_channel',
        'Urgent Alerts',
        description: 'Urgent notifications with alarm sound.',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('alarm1'),
      );

  static const AndroidNotificationChannel generalChannel =
      AndroidNotificationChannel(
        'general_alerts_channel',
        'General Alerts',
        description: 'General notifications with default alert.',
        importance: Importance.defaultImportance,
        sound: RawResourceAndroidNotificationSound('alarm_general'),
      );

  //--------------------------------------------------------------------
  // INITIALIZATION
  //--------------------------------------------------------------------
  Future<void> initializeNotifications() async {
    await _initLocalNotifications();
    await _requestPermissions();
    await _setupInteractions();
    _handleForegroundMessages();
    await getFCMToken();
  }

  //--------------------------------------------------------------------
  // LOCAL NOTIFICATION SETUP
  //--------------------------------------------------------------------
  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );

    const initSettings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) {
        _handleMessageAction(resp.payload);
      },
    );

    final androidImpl = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImpl?.createNotificationChannel(urgentChannel);
    await androidImpl?.createNotificationChannel(generalChannel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //--------------------------------------------------------------------
  // Permission
  //--------------------------------------------------------------------
  Future<void> _requestPermissions() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    log("Permission: ${settings.authorizationStatus}");
  }

  //--------------------------------------------------------------------
  // GET TOKEN
  //--------------------------------------------------------------------
  Future<void> getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      fcmToken.value = token;
      loginRepo.saveFcmToken(token);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      loginRepo.saveFcmToken(newToken);
    });
  }

  //--------------------------------------------------------------------
  // TAP ON NOTIFICATION → NAVIGATION
  //--------------------------------------------------------------------
  void _handleMessageAction(String? route) {
    Get.to(() => HomeScreen(), arguments: {'navigateToNotifications': true});
    Get.find<HomeController>().changeNavIndex(2);
  }

  //--------------------------------------------------------------------
  // TERMINATED / BACKGROUND HANDLERS
  //--------------------------------------------------------------------
  Future<void> _setupInteractions() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      _handleMessageAction(initialMessage.data['route']);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _handleMessageAction(msg.data['route']);
    });
  }

  //--------------------------------------------------------------------
  // FOREGROUND HANDLING WITH SOUND LOGIC
  //--------------------------------------------------------------------
  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      RemoteNotification? notif = msg.notification;

      // READ FROM DATA PAYLOAD
      String soundType = msg.data['sound_type'] ?? 'general';

      AndroidNotificationChannel channel;
      String iosSound;

      if (soundType == 'urgent') {
        channel = urgentChannel;
        iosSound = "alarm_urgent.mp3";
      } else {
        channel = generalChannel;
        iosSound = "alarm_general.mp3";
      }

      if (notif != null) {
        _localNotifications.show(
          notif.hashCode,
          notif.title,
          notif.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              sound: channel.sound,
              importance: channel.importance,
              priority: Priority.max,
            ),
            iOS: DarwinNotificationDetails(sound: iosSound),
          ),
          payload: msg.data['route'],
        );
      }
    });
  }

  //--------------------------------------------------------------------
  // YOUR OTHER EXISTING FUNCTIONS (unchanged)
  //--------------------------------------------------------------------
  // markAsRead(), getNotifications(), etc...

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

  markAsRead() async {
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

  Future<bool> shouldNavigateToNotificationsTab() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      return true;
    }
    return false;
  }
}
