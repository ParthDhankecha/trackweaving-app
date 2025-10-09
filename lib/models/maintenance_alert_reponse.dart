// To parse this JSON data, do
//
//     final maintenanceAlertListResponse = maintenanceAlertListResponseFromMap(jsonString);

import 'dart:convert';

MaintenanceAlertListResponse maintenanceAlertListResponseFromMap(String str) =>
    MaintenanceAlertListResponse.fromMap(json.decode(str));

String maintenanceAlertListResponseToMap(MaintenanceAlertListResponse data) =>
    json.encode(data.toMap());

class MaintenanceAlertListResponse {
  String code;
  String message;
  List<MaintenanceEntryModel> data;

  MaintenanceAlertListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MaintenanceAlertListResponse.fromMap(Map<String, dynamic> json) =>
      MaintenanceAlertListResponse(
        code: json["code"],
        message: json["message"],
        data: List<MaintenanceEntryModel>.from(
          json["data"].map((x) => MaintenanceEntryModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class MaintenanceEntryModel {
  String machineId;
  String machineCode;
  String machineName;
  List<Alert> alerts;

  MaintenanceEntryModel({
    required this.machineId,
    required this.machineCode,
    required this.machineName,
    required this.alerts,
  });

  factory MaintenanceEntryModel.fromMap(Map<String, dynamic> json) =>
      MaintenanceEntryModel(
        machineId: json["machineId"],
        machineCode: json["machineCode"],
        machineName: json["machineName"],
        alerts: List<Alert>.from(json["alerts"].map((x) => Alert.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "machineId": machineId,
    "machineCode": machineCode,
    "machineName": machineName,
    "alerts": List<dynamic>.from(alerts.map((x) => x.toMap())),
  };
}

class Alert {
  String id;
  String maintenanceCategoryId;
  String machineId;
  DateTime nextMaintenanceDate;
  bool isDue;
  int? scheduleDays;
  String categoryName;

  Alert({
    required this.id,
    required this.maintenanceCategoryId,
    required this.machineId,
    required this.nextMaintenanceDate,
    required this.isDue,
    required this.categoryName,
    this.scheduleDays = 0,
  });

  factory Alert.fromMap(Map<String, dynamic> json) => Alert(
    id: json["_id"],
    maintenanceCategoryId: json["maintenanceCategoryId"],
    machineId: json["machineId"],
    nextMaintenanceDate: DateTime.parse(json["nextMaintenanceDate"]),
    isDue: json["isDue"],
    categoryName: json["categoryName"],
    scheduleDays: json['scheduleDays'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "maintenanceCategoryId": maintenanceCategoryId,
    "machineId": machineId,
    "nextMaintenanceDate": nextMaintenanceDate.toIso8601String(),
    "isDue": isDue,
    "categoryName": categoryName,
    "scheduleDays": scheduleDays,
  };
}
