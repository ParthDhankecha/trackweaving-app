import 'dart:convert';

import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class DashboardRepo {
  final ApiClient apiClient;

  DashboardRepo({required this.apiClient});

  Sharedprefs sp = Get.find<Sharedprefs>();

  Future<GetMachineLogModel> getMachineLogs({String status = 'all'}) async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machineLogs);

    var data = await apiClient.request(
      endPoint,
      method: ApiType.post,
      body: {'status': status},
      headers: {'authorization': sp.userToken},
    );

    GetMachineLogModel getMachineLogModel = getMachineLogModelFromMap(data);
    return getMachineLogModel;
  }

  //settings api
  Future<dynamic> getConfiguration() async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.configuration);

    var data = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );

    var settings = jsonDecode(data);
    return settings['data'];
  }
}
