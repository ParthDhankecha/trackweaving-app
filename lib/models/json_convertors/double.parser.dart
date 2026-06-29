part of 'serializer.dart';

class DoubleParser implements JsonConverter<double, Object?> {
  const DoubleParser();

  @override
  double fromJson(Object? val) {
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? -1;
    return -1;
  }

  @override
  Object? toJson(double val) => '$val';
}

class DoubleNullParser implements JsonConverter<double?, Object?> {
  const DoubleNullParser();

  @override
  double? fromJson(Object? val) {
    if (val == null) return null;
    if (val is double) return val;
    if (val is String) return double.tryParse(val);
    return null;
  }

  @override
  Object? toJson(double? val) => val?.toStringAsFixed(2);
}
