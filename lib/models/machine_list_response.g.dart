// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineListResponse _$MachineListResponseFromJson(Map<String, dynamic> json) =>
    MachineListResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Machine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Machine _$MachineFromJson(Map<String, dynamic> json) => Machine(
  id: json['_id'] as String,
  machineGroup: json['machineGroupId'] == null
      ? null
      : MachineGroup.fromJson(json['machineGroupId'] as Map<String, dynamic>),
  serialNumber: json['serialNumber'] as String,
  machineCode: json['machineCode'] as String,
  machineName: json['machineName'] as String,
  ip: json['ip'] as String,
  isAlertActive: json['isAlertActive'] == null
      ? false
      : const BoolParser.falseV().fromJson(json['isAlertActive']),
  maxSpeedLimit: json['maxSpeedLimit'] == null
      ? 0
      : const NumParser().fromJson(json['maxSpeedLimit']),
  quality: json['quality'] as String? ?? '',
);
