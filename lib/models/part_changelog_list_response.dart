// To parse this JSON data, do
//
//     final partChangeLogListResponse = partChangeLogListResponseFromMap(jsonString);

import 'dart:convert';

PartChangeLogListResponse partChangeLogListResponseFromMap(String str) =>
    PartChangeLogListResponse.fromMap(json.decode(str));

String partChangeLogListResponseToMap(PartChangeLogListResponse data) =>
    json.encode(data.toMap());

class PartChangeLogListResponse {
  String code;
  String message;
  PartChangeLogList data;

  PartChangeLogListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PartChangeLogListResponse.fromMap(Map<String, dynamic> json) =>
      PartChangeLogListResponse(
        code: json["code"],
        message: json["message"],
        data: PartChangeLogList.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class PartChangeLogList {
  List<PartChangeLog> partChangeLogs;
  int page;
  int limit;

  PartChangeLogList({
    required this.partChangeLogs,
    required this.page,
    required this.limit,
  });

  factory PartChangeLogList.fromMap(Map<String, dynamic> json) =>
      PartChangeLogList(
        partChangeLogs: List<PartChangeLog>.from(
          json["partChangeLogs"].map((x) => PartChangeLog.fromMap(x)),
        ),
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toMap() => {
    "partChangeLogs": List<dynamic>.from(partChangeLogs.map((x) => x.toMap())),
    "page": page,
    "limit": limit,
  };
}

class PartChangeLog {
  String id;
  MachineId machineId;
  //String workspaceId;
  String partName;
  DateTime changeDate;
  String changedBy;
  String? changedByContact;
  String? notes;

  PartChangeLog({
    required this.id,
    required this.machineId,
    //required this.workspaceId,
    required this.partName,
    required this.changeDate,
    required this.changedBy,
    this.changedByContact,
    required this.notes,
  });

  factory PartChangeLog.fromMap(Map<String, dynamic> json) => PartChangeLog(
    id: json["_id"],
    machineId: MachineId.fromMap(json["machineId"]),
    //workspaceId: json["workspaceId"],
    partName: json["partName"],
    changeDate: DateTime.parse(json["changeDate"]),
    changedBy: json["changedBy"],
    changedByContact: json["changedByContact"],
    notes: json["notes"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "machineId": machineId.toMap(),
    //"workspaceId": workspaceId,
    "partName": partName,
    "changeDate": changeDate.toIso8601String(),
    "changedBy": changedBy,
    "changedByContact": changedByContact,
    "notes": notes,
  };
}

class MachineId {
  String id;
  String machineCode;
  String machineName;

  MachineId({
    required this.id,
    required this.machineCode,
    required this.machineName,
  });

  factory MachineId.fromMap(Map<String, dynamic> json) => MachineId(
    id: json["_id"],
    machineCode: json["machineCode"],
    machineName: json["machineName"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "machineCode": machineCode,
    "machineName": machineName,
  };
}
