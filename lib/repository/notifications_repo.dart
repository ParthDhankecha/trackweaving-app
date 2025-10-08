import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/models/notifications_list_response.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class NotificationsRepo extends GetxService {
  ApiClient apiClient = Get.find();
  Sharedprefs sp = Get.find();

  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    String endPoint = AppConst.getUrl('${AppConst.notifications}/list');
    List<NotificationModel> notifications = [];

    var data = await apiClient.request(
      endPoint,
      headers: {'Authorization': sp.userToken},
      method: ApiType.post,
      body: {'page': page},
    );

    if (data != null) {
      NotificationsListResponse response = notificationsListResponseFromMap(
        data,
      );
      notifications = response.data;
    }

    return notifications;
  }

  //mark-as-read
  Future<bool> markAsRead(List<String> notificationIds) async {
    String endPoint = AppConst.getUrl('${AppConst.notifications}/mark-as-read');

    var response = await apiClient.request(
      endPoint,
      headers: {'Authorization': sp.userToken},
      method: ApiType.put,
      body: {'notificationIds': notificationIds},
    );

    var data = jsonDecode(response);
    if (data != null) {
      return data['code'] == 'OK';
    }

    return false;
  }

  Future<int> getUnreadCount() async {
    String endPoint = AppConst.getUrl('${AppConst.notifications}/unread-count');

    var response = await apiClient.request(
      endPoint,
      headers: {'Authorization': sp.userToken},
    );

    var data = jsonDecode(response);
    log('data : $data');
    log('Unread Count Response: ${data['count']}');
    if (data != null && data['code'] == 'OK') {
      return data['data']['count'] ?? 0;
    }

    return 0;
  }
}
