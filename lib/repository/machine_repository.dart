import 'dart:convert';
import 'dart:developer';

import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/models/machine_list_response_model.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/utils/app_const.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class MachineRepository {
  final ApiClient apiClient;

  MachineRepository({required this.apiClient});

  Sharedprefs sp = Get.find<Sharedprefs>();

  //list of machine groups
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

  Future<dynamic> updateMachineConfiguration({
    required String id,
    required String machineCode,
    required String machineName,
    required String machineGroupId,
    required bool isAlertActive,
  }) async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machines);
    var reqBody = {
      'machineCode': machineCode,
      'machineName': machineName,
      'machineGroupId': machineGroupId,
      'isAlertActive': '$isAlertActive',
    };

    log('end point :: $endPoint');
    log('req body  : $reqBody');
    log('token:: ${sp.userToken}');

    var data = await apiClient.request(
      '$endPoint/$id',
      body: reqBody,
      headers: {'authorization': sp.userToken},
      method: ApiType.put,
    );
    log('result body  : $data');
    return data;
  }

  Future<dynamic> updateMachineConfigurationAlert({
    required String id,

    required bool isAlertActive,
  }) async {
    String endPoint = AppConst.getUrl(sp.hostUrl, AppConst.machines);
    var reqBody = {'isAlertActive': '$isAlertActive'};
    log('end point :: $endPoint');
    log('req body  : $reqBody');
    log('token:: ${sp.userToken}');

    var data = await apiClient.request(
      '$endPoint/$id',
      body: reqBody,
      headers: {'authorization': sp.userToken},
      method: ApiType.put,
    );
    log('result body  : $data');
    return data;
  }
}
