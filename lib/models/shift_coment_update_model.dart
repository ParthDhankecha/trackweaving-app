import 'dart:convert';

ShiftCommentUpdateModel shiftCommentUpdateModelFromMap(String str) =>
    ShiftCommentUpdateModel.fromMap(json.decode(str));

String shiftCommentUpdateModelToMap(ShiftCommentUpdateModel data) =>
    json.encode(data.toMap());

class ShiftCommentUpdateModel {
  List<CommentUpdateModel> list;

  ShiftCommentUpdateModel({required this.list});

  factory ShiftCommentUpdateModel.fromMap(Map<String, dynamic> json) =>
      ShiftCommentUpdateModel(
        list: List<CommentUpdateModel>.from(
          json["list"].map((x) => CommentUpdateModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
  };
}

class CommentUpdateModel {
  String machineId;
  DateTime date;
  String shift;
  String comment;

  CommentUpdateModel({
    required this.machineId,
    required this.date,
    required this.shift,
    required this.comment,
  });

  factory CommentUpdateModel.fromMap(Map<String, dynamic> json) =>
      CommentUpdateModel(
        machineId: json["machineId"],
        date: DateTime.parse(json["date"]),
        shift: json["shift"],
        comment: json["comment"],
      );

  Map<String, dynamic> toMap() => {
    "machineId": machineId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "shift": shift,
    "comment": comment,
  };
}
