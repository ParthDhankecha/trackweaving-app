// To parse this JSON data, do
//
//     final loginAuth = loginAuthFromMap(jsonString);

import 'dart:convert';

LoginAuth loginAuthFromMap(String str) => LoginAuth.fromMap(json.decode(str));

String loginAuthToMap(LoginAuth data) => json.encode(data.toMap());

class LoginAuth {
  String code;
  String message;
  AuthData data;

  LoginAuth({required this.code, required this.message, required this.data});

  factory LoginAuth.fromMap(Map<String, dynamic> json) => LoginAuth(
    code: json["code"],
    message: json["message"],
    data: AuthData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class AuthData {
  Token token;
  User user;

  AuthData({required this.token, required this.user});

  factory AuthData.fromMap(Map<String, dynamic> json) => AuthData(
    token: Token.fromMap(json["token"]),
    user: User.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "token": token.toMap(),
    "user": user.toMap(),
  };
}

class Token {
  int expiresIn;
  String accessToken;

  Token({required this.expiresIn, required this.accessToken});

  factory Token.fromMap(Map<String, dynamic> json) =>
      Token(expiresIn: json["expiresIn"], accessToken: json["accessToken"]);

  Map<String, dynamic> toMap() => {
    "expiresIn": expiresIn,
    "accessToken": accessToken,
  };
}

class User {
  String id;
  int type;

  User({required this.id, required this.type});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["_id"], type: json["type"]);

  Map<String, dynamic> toMap() => {"_id": id, "type": type};
}
