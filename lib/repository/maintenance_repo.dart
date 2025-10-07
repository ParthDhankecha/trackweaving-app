import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/models/maintenance_alert_reponse.dart';
import 'package:trackweaving/models/maintenance_category_list_model.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class MaintenanceRepo extends GetxService {
  final Sharedprefs sp;
  final ApiClient apiClient;
  MaintenanceRepo(this.apiClient, {required this.sp});

  Future<List<MaintenanceCategory>> getMaintenanceCategoryList() async {
    String endPoint = AppConst.getUrl(AppConst.maintenanceCategories);
    var data = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );
    List<MaintenanceCategory> list = [];
    list = maintenanceCategoryListResponseModelFromMap(data).data;
    return list;
  }

  //get all maintenance alert list for maintenance entry
  Future<List<MaintenanceEntryModel>> getMaintenanceAlert() async {
    String endPoint = AppConst.getUrl(AppConst.maintenanceAlert);
    var data = await apiClient.request(
      endPoint,
      headers: {
        'authorization': sp.userToken,
        'Content-Type': 'application/json',
      },
    );
    List<MaintenanceEntryModel> list = [];
    list = maintenanceAlertListResponseFromMap(data).data;
    return list;
  }

  Future<dynamic> updateAlertEntry({
    required String id,
    String? machineId,
    String? maintenanceCategoryId,
    required String nextMaintenanceDate,
    required String lastMaintenanceDate,
    String? remarks,
    String? completedBy,
    String? completedByMobile,
  }) async {
    String endPoint = AppConst.getUrl(AppConst.maintenanceAlert);

    var reqBody = {
      if (maintenanceCategoryId != null)
        'maintenanceCategoryId': maintenanceCategoryId,
      if (machineId != null) 'machineId': machineId,
      'nextMaintenanceDate': nextMaintenanceDate,
      'lastMaintenanceDate': lastMaintenanceDate,
      if (remarks != null) 'remarks': remarks,
      'completedBy': completedBy,
      'completedByMobile': completedByMobile,
    };

    log('-------Update entry-------');
    log('$endPoint/$id');
    log('$reqBody');
    var data = await apiClient.request(
      '$endPoint/$id',
      headers: {
        'authorization': sp.userToken,
        'Content-Type': 'application/json',
      },
      body: reqBody,
      method: ApiType.put,
    );

    return data;
  }

  //change maintenance category status
  Future<dynamic> changeCategoryStatus({
    required String id,
    required bool status,
  }) async {
    String endPoint = AppConst.getUrl(AppConst.maintenanceCategories);
    var data = await apiClient.request(
      '$endPoint/$id',
      headers: {'authorization': sp.userToken},
      body: {'isActive': '$status', 'Content-Type': 'application/json'},
      method: ApiType.put,
    );

    return data;
  }
}
