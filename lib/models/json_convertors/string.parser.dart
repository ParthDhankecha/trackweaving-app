part of 'serializer.dart';

class ForceStringParser implements JsonConverter<String, Object?> {
  const ForceStringParser();

  @override
  String fromJson(Object? val) {
    return switch (val) {
      String value => value,
      int value => '$value',
      double value => value.toStringPro(),
      _ => '',
    };
  }

  @override
  Object? toJson(String val) => val;
}
