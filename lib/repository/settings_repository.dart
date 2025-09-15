import 'dart:convert';
import 'dart:developer';

import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class SettingsRepository {
  final ApiClient apiClient;

  SettingsRepository({required this.apiClient});

  Sharedprefs sp = Get.find<Sharedprefs>();

  //lsit of machine groups
  Future<List<MachineGroup>> getMachineGroupList() async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machineGrp);
    var data = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );
    List<MachineGroup> list = [];
    list = machineGroupResponseModelFromMap(data).data;
    return list;
  }

  //create and update machine group
  Future<dynamic> createUpdateMachineGroup({
    required String name,
    String id = '',
    bool isUpdate = false,
  }) async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machineGrp);

    var reqBody = isUpdate
        ? {'groupName': name, 'id': id}
        : {'groupName': name};
    log('end point :: $endPoint');
    log('req body  : $reqBody');
    log('token:: ${sp.userToken}');
    var data = isUpdate
        ? await apiClient.request(
            '$endPoint/$id',
            method: ApiType.put,
            body: reqBody,
            headers: {'authorization': sp.userToken},
          )
        : await apiClient.request(
            endPoint,
            method: ApiType.post,
            body: reqBody,
            headers: {'authorization': sp.userToken},
          );

    log('response : $data');
    return jsonDecode(data);
  }

  Future<List<Machine>> getMachineList() async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machines);
    var data = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );
    List<Machine> list = [];
    list = machineListResponseModelFromMap(data).data;
    return list;
  }
}
