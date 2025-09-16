// To parse this JSON data, do
//
//     final machineListResponseModel = machineListResponseModelFromMap(jsonString);

import 'dart:convert';

import 'package:flutter_texmunimx/models/machine_group_response_model.dart';

MachineListResponseModel machineListResponseModelFromMap(String str) =>
    MachineListResponseModel.fromMap(json.decode(str));

String machineListResponseModelToMap(MachineListResponseModel data) =>
    json.encode(data.toMap());

class MachineListResponseModel {
  String code;
  String message;
  List<Machine> data;

  MachineListResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MachineListResponseModel.fromMap(Map<String, dynamic> json) =>
      MachineListResponseModel(
        code: json["code"],
        message: json["message"],
        data: List<Machine>.from(json["data"].map((x) => Machine.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Machine {
  MachineGroup? machineGroupId;
  String id;
  String serialNumber;
  String machineCode;
  String machineName;
  String ip;
  bool isAlertActive;

  Machine({
    required this.machineGroupId,
    required this.id,
    required this.serialNumber,
    required this.machineCode,
    required this.machineName,
    required this.ip,
    required this.isAlertActive,
  });

  factory Machine.fromMap(Map<String, dynamic> json) => Machine(
    machineGroupId: json["machineGroupId"] != null
        ? MachineGroup.fromMap(json['machineGroupId'])
        : null,
    id: json["_id"],
    serialNumber: json["serialNumber"],
    machineCode: json["machineCode"],
    machineName: json["machineName"],
    ip: json["ip"],
    isAlertActive: json["isAlertActive"],
  );

  Map<String, dynamic> toMap() => {
    "machineGroupId": machineGroupId,
    "_id": id,
    "serialNumber": serialNumber,
    "machineCode": machineCode,
    "machineName": machineName,
    "ip": ip,
    "isAlertActive": isAlertActive,
  };
}
