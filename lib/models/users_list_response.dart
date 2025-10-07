// To parse this JSON data, do
//
//     final usersListResponse = usersListResponseFromMap(jsonString);

import 'dart:convert';

UsersListResponse usersListResponseFromMap(String str) =>
    UsersListResponse.fromMap(json.decode(str));

String usersListResponseToMap(UsersListResponse data) =>
    json.encode(data.toMap());

class UsersListResponse {
  String code;
  String message;
  List<UserModel> data;

  UsersListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory UsersListResponse.fromMap(Map<String, dynamic> json) =>
      UsersListResponse(
        code: json["code"],
        message: json["message"],
        data: List<UserModel>.from(
          json["data"].map((x) => UserModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class UserModel {
  String id;
  String fullname;
  String userName;
  String mobile;
  String email;
  bool isActive;

  UserModel({
    required this.id,
    required this.fullname,

    required this.userName,
    required this.mobile,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    fullname: json["fullname"],

    userName: json["userName"],
    mobile: json["mobile"],
    email: json["email"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "fullname": fullname,
    "userName": userName,
    "mobile": mobile,
    "email": email,
    "isActive": isActive,
  };
}

class Plan {
  dynamic startDate;
  dynamic endDate;
  int subUserLimit;

  Plan({
    required this.startDate,
    required this.endDate,
    required this.subUserLimit,
  });

  factory Plan.fromMap(Map<String, dynamic> json) => Plan(
    startDate: json["startDate"],
    endDate: json["endDate"],
    subUserLimit: json["subUserLimit"],
  );

  Map<String, dynamic> toMap() => {
    "startDate": startDate,
    "endDate": endDate,
    "subUserLimit": subUserLimit,
  };
}
