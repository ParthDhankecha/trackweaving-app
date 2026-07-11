import 'json_convertors/serializer.dart';

part 'machine_group_response.g.dart';

@CustomSerializer
class MachineGroupResponse {
  String code;
  String message;
  List<MachineGroup> data;

  MachineGroupResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MachineGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$MachineGroupResponseFromJson(json);
}

@CustomSerializer
class MachineGroup {
  @JsonKey(name: '_id')
  String id;
  String groupName;

  MachineGroup({required this.id, required this.groupName});

  factory MachineGroup.fromJson(Map<String, dynamic> json) =>
      _$MachineGroupFromJson(json);
}
