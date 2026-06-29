part of 'serializer.dart';

class DateParser implements JsonConverter<DateTime, Object?> {
  const DateParser();

  @override
  DateTime fromJson(Object? val) {
    if (val is String) {
      return DateTime.tryParse(val) ?? DateTime.now();
    }
    throw FormatException('The value "$val" in not date parsable.');
  }

  @override
  Object? toJson(DateTime val) => val.toIso8601String();
}

class DateNullParser implements JsonConverter<DateTime?, Object?> {
  const DateNullParser();

  @override
  DateTime? fromJson(Object? val) {
    if (val is String) return DateTime.tryParse(val);
    return null;
  }

  @override
  Object? toJson(DateTime? val) => val?.toIso8601String();
}
