import 'dart:convert';

ShiftCommentListResponse shiftCommentListResponseFromMap(String str) =>
    ShiftCommentListResponse.fromMap(json.decode(str));

String shiftCommentListResponseToMap(ShiftCommentListResponse data) =>
    json.encode(data.toMap());

class ShiftCommentListResponse {
  String code;
  String message;
  Data data;

  ShiftCommentListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ShiftCommentListResponse.fromMap(Map<String, dynamic> json) =>
      ShiftCommentListResponse(
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  List<ShiftComment> list;

  Data({required this.list});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    list: List<ShiftComment>.from(
      json["list"].map((x) => ShiftComment.fromMap(x)),
    ),
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
  };
}

class ShiftComment {
  String id;
  DateTime date;
  bool isDeleted;
  String machineId;
  String shift;
  String workspaceId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;

  ShiftComment({
    required this.id,
    required this.date,
    required this.isDeleted,
    required this.machineId,
    required this.shift,
    required this.workspaceId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShiftComment.fromMap(Map<String, dynamic> json) => ShiftComment(
    id: json["_id"],
    date: DateTime.parse(json["date"]).toLocal(),
    isDeleted: json["isDeleted"],
    machineId: json["machineId"],
    shift: json["shift"],
    workspaceId: json["workspaceId"],
    comment: json["comment"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "date": date.toIso8601String(),
    "isDeleted": isDeleted,
    "machineId": machineId,
    "shift": shift,
    "workspaceId": workspaceId,
    "comment": comment,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
