part of 'serializer.dart';

enum ParseMode { full, seconds, minutes, hours }

class DurationParser implements JsonConverter<Duration, Object?> {
  const DurationParser.full() : mode = ParseMode.full;
  const DurationParser.seconds() : mode = ParseMode.seconds;
  const DurationParser.minutes() : mode = ParseMode.minutes;
  const DurationParser.hours() : mode = ParseMode.hours;

  final ParseMode mode;

  @override
  Duration fromJson(Object? val) {
    if (mode == ParseMode.seconds) {
      if (val is int) return Duration(seconds: val);
      if (val is String) {
        final seconds = int.tryParse(val);
        if (seconds != null) return Duration(seconds: seconds);
      }
    } else if (mode == ParseMode.minutes) {
      if (val is int) return Duration(minutes: val);
      if (val is String) {
        final minutes = int.tryParse(val);
        if (minutes != null) return Duration(minutes: minutes);
      }
    } else if (mode == ParseMode.hours) {
      if (val is int) return Duration(hours: val);
      if (val is String) {
        final hours = int.tryParse(val);
        if (hours != null) return Duration(hours: hours);
      }
    } else {
      if (val is String && RegExp(r'^\d+(:\d{1,2}){0,2}$').hasMatch(val)) {
        final parts = val.split(':');
        final hours = int.tryParse(parts.elementAtOrNull(0) ?? '0') ?? 0;
        final minutes = int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0;
        final seconds = int.tryParse(parts.elementAtOrNull(2) ?? '0') ?? 0;
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }
    throw Exception('The value "$val" is not duration parsable.');
  }

  @override
  Object? toJson(Duration val) {
    return '${val.inHours}:${val.inMinutes.remainder(60)}:${val.inSeconds.remainder(60)}';
  }
}
