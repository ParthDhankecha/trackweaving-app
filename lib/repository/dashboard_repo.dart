import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/models/machine_log_response.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class DashboardRepo extends GetxService {
  final ApiClient apiClient;

  DashboardRepo({required this.apiClient});

  Sharedprefs sp = Get.find<Sharedprefs>();

  Future<MachineLogResponse> getMachineLogs({String status = 'all'}) async {
    String endPoint = AppConst.getUrl(AppConst.machineLogs);

    var data = await apiClient.request(
      endPoint,
      method: ApiType.post,
      body: {'status': status},
      headers: {'authorization': sp.userToken},
    );
    final json = jsonDecode(data);
    return MachineLogResponse.fromJson(json);
  }

  //settings api
  Future<dynamic> getConfiguration() async {
    String endPoint = AppConst.getUrl(AppConst.configuration);

    var data = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );

    var settings = jsonDecode(data);
    log('settings data: $settings');
    return settings['data'];
  }
}
