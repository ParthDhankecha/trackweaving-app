import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/models/report_response.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class ReportRepository extends GetxService {
  // Define your methods and properties here

  ApiClient apiClient = Get.find<ApiClient>();
  Sharedprefs sp = Get.find<Sharedprefs>();

  Future<ReportsResponse> getReportData(
    List<String> machineIds,
    String startDate,
    String endDate,
    List<int> shift,
    String reportType,
  ) async {
    var body = {
      'machineIds': machineIds,
      'startDate': startDate,
      'endDate': endDate,
      'shift': shift,
      'reportType': reportType,
    };

    String endpoint = AppConst.getUrl(AppConst.reports);
    var data = await apiClient.request(
      endpoint,
      method: ApiType.post,
      body: body,
      headers: {'Authorization': sp.userToken},
    );

    return reportsResponseFromMap(data);
  }
}
