import 'dart:convert';

import 'package:get/get.dart';
import 'package:trackweaving/models/api_response_mode.dart';
import 'package:trackweaving/models/part_changelog_list_response.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/date_formate_extension.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class MachinePartsRepo extends GetxService {
  // Define your repository methods and properties here

  ApiClient apiClient = Get.find<ApiClient>();
  Sharedprefs sharedprefs = Get.find<Sharedprefs>();

  //api to fetch list of parts
  Future<List<String>> fetchPartsList() async {
    List<String> parts = [];
    final response = await apiClient.request(
      AppConst.getUrl(AppConst.partsList),
      headers: {'authorization': sharedprefs.userToken},
    );
    final json = jsonDecode(response);
    parts = List<String>.from(json["data"].map((x) => x));
    return parts;
  }

  Future<List<PartChangeLog>> getchangeLogs(
    List<String> machineIds,
    int page,
  ) async {
    final response = await apiClient.request(
      AppConst.getUrl('${AppConst.parts}/list'),
      headers: {'authorization': sharedprefs.userToken},
      method: ApiType.post,
      body: {"machineIds": machineIds, "page": page},
    );

    var partChangeLogListResponse = partChangeLogListResponseFromMap(response);
    return partChangeLogListResponse.data.partChangeLogs;
  }

  Future<bool> createPartChangeLog({
    required String machineId,
    required String partName,
    required String name,
    required DateTime changeDate,
    String? phone,
    String? notes,
  }) async {
    final body = {
      "machineId": machineId,
      "partName": partName,
      "changedBy": name,
      "changeDate": changeDate.ddmmyyFormat,
      "changedByContact": phone,
      "notes": notes,
    };

    final response = await apiClient.request(
      AppConst.getUrl(AppConst.parts),
      method: ApiType.post,
      body: body,
      headers: {'authorization': sharedprefs.userToken},
    );
    bool success = response != null;
    return success;
  }

  Future<PartChangeLog> updatePartChangeLog({
    required String id,
    required String machineId,
    required String partName,
    required String name,
    required DateTime changeDate,
    String? phone,
    String? notes,
  }) async {
    final body = {
      "machineId": machineId,
      "partName": partName,
      "changedBy": name,
      "changeDate": changeDate.ddmmyyFormat,
      "changedByContact": phone,
      "notes": notes,
    };

    final response = await apiClient.request(
      AppConst.getUrl('${AppConst.parts}/$id'),
      method: ApiType.put,
      body: body,
      headers: {'authorization': sharedprefs.userToken},
    );
    PartChangeLog part = ApiResponse.fromJson(
      jsonDecode(response),
      PartChangeLog.fromMap,
    ).data!;
    return part;
  }
}
