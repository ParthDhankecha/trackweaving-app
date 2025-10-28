import 'dart:convert';
import 'dart:developer';

import 'package:trackweaving/models/machine_group_response_model.dart';
import 'package:trackweaving/models/machine_list_response_model.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/utils/app_const.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class MachineRepository extends GetxService {
  final ApiClient apiClient;

  MachineRepository({required this.apiClient});

  Sharedprefs sp = Get.find<Sharedprefs>();

  //list of machine groups
  Future<List<MachineGroup>> getMachineGroupList() async {
    String endPoint = AppConst.getUrl(AppConst.machineGrp);
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
    String endPoint = AppConst.getUrl(AppConst.machineGrp);

    var reqBody = isUpdate
        ? {'groupName': name, 'id': id}
        : {'groupName': name};

    var data = isUpdate
        ? await apiClient.request(
            '$endPoint/$id',
            method: ApiType.put,
            body: reqBody,
            headers: {
              'authorization': sp.userToken,
              'Content-Type': 'application/json',
            },
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
    String endPoint = AppConst.getUrl(AppConst.machines);
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
    required String machineMaxLimit,
  }) async {
    String endPoint = AppConst.getUrl(AppConst.machines);
    var reqBody = {
      'machineCode': machineCode,
      'machineName': machineName,
      'machineGroupId': machineGroupId,
      'isAlertActive': '$isAlertActive',
      'maxSpeedLimit': int.tryParse(machineMaxLimit) ?? 0,
    };

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
    String endPoint = AppConst.getUrl(AppConst.machines);
    var reqBody = {'isAlertActive': '$isAlertActive'};

    var data = await apiClient.request(
      '$endPoint/$id',
      body: reqBody,
      headers: {
        'authorization': sp.userToken,
        'Content-Type': 'application/json',
      },
      method: ApiType.put,
    );
    log('result body  : $data');
    return data;
  }
}
