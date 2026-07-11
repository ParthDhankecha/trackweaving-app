// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineGroupResponse _$MachineGroupResponseFromJson(
  Map<String, dynamic> json,
) => MachineGroupResponse(
  code: json['code'] as String,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => MachineGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
);

MachineGroup _$MachineGroupFromJson(Map<String, dynamic> json) => MachineGroup(
  id: json['_id'] as String,
  groupName: json['groupName'] as String,
);
