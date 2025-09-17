import 'dart:convert';

import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';

class ShiftCommentRepository {
  final Sharedprefs sp;
  final ApiClient apiClient;

  ShiftCommentRepository({required this.sp, required this.apiClient});

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
