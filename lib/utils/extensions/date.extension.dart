import 'package:flutter/material.dart' show TimeOfDay;
import 'package:intl/intl.dart';

extension Simplify on DateTime {
  String get apiFormat {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get format {
    return DateFormat('MMMM dd, yyyy').format(this);
  }

  String get shortFormat {
    return DateFormat('dd MMM yyyy, hh:mm a').format(this);
  }

  String get fullFormat {
    return DateFormat("MMMM dd, yyyy 'at' hh:mm a").format(this);
  }

  String get dayName => DateFormat('EEE').format(this);
  String get monthName => DateFormat('MMM').format(this);

  DateTime withTime(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String get hr12Format {
    final hour12Str = hourOfPeriod.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour12Str:$minuteStr ${period.name.toUpperCase()}';
  }

  String get hr24Format {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}
