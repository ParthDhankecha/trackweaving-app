import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/repository/notifications_repo.dart';

class HomeController extends GetxController implements GetxService {
  HomeController();

  RxInt selectedNavIndex = 0.obs;
  final unreadNotificationCount = 0.obs;

  NotificationsRepo notificationsRepo = Get.find();

  void changeNavIndex(int i) {
    selectedNavIndex.value = i;

    if (i == 2) {
      clearUnreadCount();
    }
  }

  void fetchUnreadCount() async {
    final int mockCountFromApi = await notificationsRepo.getUnreadCount();
    unreadNotificationCount.value = mockCountFromApi;
    debugPrint('Unread notification count fetched: $mockCountFromApi');
  }

  void clearUnreadCount() {
    unreadNotificationCount.value = 0;
  }
}
