class ShiftCommentModel {
  final String id;
  final String machineCode;
  final String machineId;
  final String shiftTime;
  final String shiftType;
  String dayComment;
  String nightComment;

  ShiftCommentModel({
    required this.id,
    required this.machineCode,
    required this.machineId,
    required this.shiftTime,
    required this.shiftType,
    this.nightComment = '',
    this.dayComment = '',
  });
}
