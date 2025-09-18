import 'dart:developer';

import 'package:flutter_texmunimx/models/shift_comment_list_response.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/date_formate_extension.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';

class ShiftCommentRepository {
  final Sharedprefs sp;
  final ApiClient apiClient;

  ShiftCommentRepository({required this.sp, required this.apiClient});

  Future<ShiftCommentListResponse> getComments({
    DateTime? date,
    String? machineId,
    String? shift,
  }) async {
    String endPoint =
        '${AppConst.getUrl(sp.hostUrl, AppConst.shiftWiseComment)}/list';

    AppConst.showLog(logText: 'url - $endPoint', tag: 'getComments');
    var reqBody = {
      if (date != null) 'date': date.ddmmyyFormat,
      if (machineId != null) 'machineId': machineId,
      if (shift != null) 'shift': shift,
    };

    AppConst.showLog(logText: 'reqBody - $reqBody', tag: 'getComments');

    var data = await apiClient.request(
      endPoint,
      body: reqBody,
      headers: {'authorization': sp.userToken},
      method: ApiType.post,
    );

    AppConst.showLog(logText: 'data - $data', tag: 'getComments');

    return shiftCommentListResponseFromMap(data);
  }

  Future updateComments(Map<String, List<Map<String, dynamic>>> payload) async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.shiftWiseComment);

    var data = await apiClient.request(
      endPoint,
      body: payload,
      headers: {
        'authorization': sp.userToken,
        'Content-Type': 'application/json',
      },
      method: ApiType.put,
    );

    return data;
  }
}
