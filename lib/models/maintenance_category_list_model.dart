// To parse this JSON data, do
//
//     final maintenanceCategoryListResponseModel = maintenanceCategoryListResponseModelFromMap(jsonString);

import 'dart:convert';

MaintenanceCategoryListResponseModel
maintenanceCategoryListResponseModelFromMap(String str) =>
    MaintenanceCategoryListResponseModel.fromMap(json.decode(str));

String maintenanceCategoryListResponseModelToMap(
  MaintenanceCategoryListResponseModel data,
) => json.encode(data.toMap());

class MaintenanceCategoryListResponseModel {
  String code;
  String message;
  List<MaintenanceCategory> data;

  MaintenanceCategoryListResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MaintenanceCategoryListResponseModel.fromMap(
    Map<String, dynamic> json,
  ) => MaintenanceCategoryListResponseModel(
    code: json["code"],
    message: json["message"],
    data: List<MaintenanceCategory>.from(
      json["data"].map((x) => MaintenanceCategory.fromMap(x)),
    ),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class MaintenanceCategory {
  String id;
  String name;
  String categoryType;
  int scheduleDays;
  int alertDays;
  //String workspaceId;
  String alertMessage;
  bool isActive;
  //bool isDeleted;
  //DateTime createdAt;
  //DateTime updatedAt;

  MaintenanceCategory({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.scheduleDays,
    required this.alertDays,
    //required this.workspaceId,
    required this.alertMessage,
    required this.isActive,
    //required this.isDeleted,
    //required this.createdAt,
    //required this.updatedAt,
  });

  factory MaintenanceCategory.fromMap(Map<String, dynamic> json) =>
      MaintenanceCategory(
        id: json["_id"],
        name: json["name"],
        categoryType: json["categoryType"],
        scheduleDays: json["scheduleDays"],
        alertDays: json["alertDays"],
        //workspaceId: json["workspaceId"],
        alertMessage: json["alertMessage"],
        isActive: json["isActive"],
        //isDeleted: json["isDeleted"],
        //createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "name": name,
    "categoryType": categoryType,
    "scheduleDays": scheduleDays,
    "alertDays": alertDays,
    //"workspaceId": workspaceId,
    "alertMessage": alertMessage,
    "isActive": isActive,
    // "isDeleted": isDeleted,
    //"createdAt": createdAt.toIso8601String(),
    //"updatedAt": updatedAt.toIso8601String(),
  };
}
