part of 'serializer.dart';

class TimeParser implements JsonConverter<TimeOfDay, Object?> {
  const TimeParser();

  @override
  TimeOfDay fromJson(Object? val) {
    if (val is String && RegExp(r'^[0-2][0-9](:[0-5][0-9]){1,2}$').hasMatch(val)) {
      final parts = val.split(':');
      if (parts.length > 1) {
        final hours = int.tryParse(parts.elementAtOrNull(0) ?? '0') ?? 0;
        final minutes = int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0;
        return TimeOfDay(hour: hours, minute: minutes);
      }
    }
    throw Exception('The value "$val" is not time parsable.');
  }

  @override
  Object? toJson(TimeOfDay val) {
    return '${val.hour}:${val.minute}';
  }
}

class TimeNullParser implements JsonConverter<TimeOfDay?, Object?> {
  const TimeNullParser();

  @override
  TimeOfDay? fromJson(Object? val) {
    if (val is String && RegExp(r'^[0-2][0-9](:[0-5][0-9]){0,2}$').hasMatch(val)) {
      final parts = val.split(':');
      if (parts.length > 1) {
        final hours = int.tryParse(parts.elementAtOrNull(0) ?? '0') ?? 0;
        final minutes = int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0;
        return TimeOfDay(hour: hours, minute: minutes);
      }
    }
    return null;
  }

  @override
  Object? toJson(TimeOfDay? val) {
    if (val == null) return null;
    return '${val.hour}:${val.minute}';
  }
}

class Time12Parser implements JsonConverter<TimeOfDay, Object?> {
  const Time12Parser();

  @override
  TimeOfDay fromJson(Object? val) {
    if (val is String && RegExp(r'^(0?[1-9]|1[0-2])(:[0-5][0-9])?\s?[aApP][mM]$').hasMatch(val)) {
      try {
        final lower = val.toLowerCase();
        final isPm = lower.endsWith('pm');
        final timePart = lower.replaceAll(RegExp(r'\s?[ap]m$'), '');
        final parts = timePart.split(':');
        int hour = int.parse(parts[0]);
        int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
        if (isPm && hour != 12) {
          hour += 12;
        } else if (!isPm && hour == 12) {
          hour = 0;
        }
        return TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        // Parsing failed, will throw below
      }
    }
    throw Exception('The value "$val" is not 12-hour time parsable.');
  }

  @override
  Object? toJson(TimeOfDay val) {
    final hour12Str = val.hourOfPeriod.toString().padLeft(2, '0');
    final minuteStr = val.minute.toString().padLeft(2, '0');
    final period = val.period.name.toUpperCase();
    return '$hour12Str:$minuteStr $period';
  }
}
