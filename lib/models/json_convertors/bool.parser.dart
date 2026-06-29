part of 'serializer.dart';

class BoolParser implements JsonConverter<bool, Object?> {
  const BoolParser.trueV() : ifNull = true;

  const BoolParser.falseV() : ifNull = false;
  final bool ifNull;

  @override
  bool fromJson(Object? val) {
    if (val == null) {
      return ifNull;
    } else if (val is bool) {
      return val;
    } else if (val is int) {
      return val == 1;
    } else if (val is String) {
      if (val == 'true' || val == '1') {
        return true;
      }
      if (val == 'false' || val == '0') {
        return false;
      }
      return (int.tryParse(val) ?? -1) > 0;
    }
    throw FormatException('The value "$val" in not bool parsable.');
  }

  @override
  Object? toJson(bool val) => '$val';
}
