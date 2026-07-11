import 'json_convertors/serializer.dart';
import 'machine_group_response.dart';

part 'machine_list_response.g.dart';

@CustomSerializer
class MachineListResponse {
  String code;
  String message;
  List<Machine> data;

  MachineListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MachineListResponse.fromJson(Map<String, dynamic> json) =>
      _$MachineListResponseFromJson(json);
}

@CustomSerializer
class Machine {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'machineGroupId')
  MachineGroup? machineGroup;
  String serialNumber;
  String machineCode;
  String machineName;
  String quality;
  String ip;
  bool isAlertActive;
  num maxSpeedLimit;

  Machine({
    required this.id,
    required this.machineGroup,
    required this.serialNumber,
    required this.machineCode,
    required this.machineName,
    required this.ip,
    this.isAlertActive = false,
    this.maxSpeedLimit = 0,
    this.quality = '',
  });

  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Machine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
