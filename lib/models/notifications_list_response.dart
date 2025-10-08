// To parse this JSON data, do
//
//     final notificationsListResponse = notificationsListResponseFromMap(jsonString);

import 'dart:convert';

NotificationsListResponse notificationsListResponseFromMap(String str) =>
    NotificationsListResponse.fromMap(json.decode(str));

String notificationsListResponseToMap(NotificationsListResponse data) =>
    json.encode(data.toMap());

class NotificationsListResponse {
  String code;
  String message;
  List<NotificationModel> data;

  NotificationsListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory NotificationsListResponse.fromMap(Map<String, dynamic> json) =>
      NotificationsListResponse(
        code: json["code"],
        message: json["message"],
        data: List<NotificationModel>.from(
          json["data"].map((x) => NotificationModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class NotificationModel {
  String id;
  String machineId;
  String userId;
  String title;
  bool isRead;
  String description;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.machineId,
    required this.userId,
    required this.title,
    required this.isRead,
    required this.description,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["_id"],
        machineId: json["machineId"] ?? '',
        userId: json["userId"] ?? '',
        title: json["title"] ?? '',
        isRead: json["isRead"] ?? false,
        description: json["description"] ?? '',
        isDeleted: json["isDeleted"] ?? false,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "machineId": machineId,
    "userId": userId,
    "title": title,
    "isRead": isRead,
    "description": description,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
