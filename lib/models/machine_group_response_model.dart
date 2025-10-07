// To parse this JSON data, do
//
//     final machineGroupResponseModel = machineGroupResponseModelFromMap(jsonString);

import 'dart:convert';

MachineGroupResponseModel machineGroupResponseModelFromMap(String str) =>
    MachineGroupResponseModel.fromMap(json.decode(str));

String machineGroupResponseModelToMap(MachineGroupResponseModel data) =>
    json.encode(data.toMap());

class MachineGroupResponseModel {
  String code;
  String message;
  List<MachineGroup> data;

  MachineGroupResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MachineGroupResponseModel.fromMap(Map<String, dynamic> json) =>
      MachineGroupResponseModel(
        code: json["code"],
        message: json["message"],
        data: List<MachineGroup>.from(
          json["data"].map((x) => MachineGroup.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class MachineGroup {
  String id;
  String groupName;
  // String workspaceId;
  // String createdBy;
  // bool isDeleted;
  // DateTime createdAt;
  // DateTime updatedAt;

  MachineGroup({
    required this.id,
    required this.groupName,
    // required this.workspaceId,
    // required this.createdBy,
    // required this.isDeleted,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory MachineGroup.fromMap(Map<String, dynamic> json) => MachineGroup(
    id: json["_id"],
    groupName: json["groupName"],
    // workspaceId: json["workspaceId"],
    // createdBy: json["createdBy"],
    // isDeleted: json["isDeleted"],
    // createdAt: DateTime.parse(json["createdAt"]),
    // updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "groupName": groupName,
    // "workspaceId": workspaceId,
    // "createdBy": createdBy,
    // "isDeleted": isDeleted,
    // "createdAt": createdAt.toIso8601String(),
    // "updatedAt": updatedAt.toIso8601String(),
  };
}
