import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get ddmmyyFormat {
    return DateFormat('dd-MMM-yyyy').format(this);
  }

  String get ddmmyyFormat2 {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  /// Formats a UTC DateTime object to a 'dd-MMM-yyyy' string.
  /// Converts the date to UTC before formatting to handle all timezones correctly.
  /// Example: '19-Jun-2025'
  String get ddmmyyUtcFormat {
    return DateFormat('dd-MMM-yyyy').format(toUtc());
  }

  String get yyyymmddFormat {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get ddmmyyhhmmssFormat {
    return DateFormat('dd/MM/yyyy hh:mm:ss a').format(this);
  }
}

List<DateTime> getDatesInMonth(DateTime selectedDate) {
  List<DateTime> dates = [];
  final year = selectedDate.year;
  final month = selectedDate.month;

  // Find the number of days in the month
  final daysInMonth = DateTime(year, month + 1, 0).day;

  for (int i = 1; i <= daysInMonth; i++) {
    dates.add(DateTime(year, month, i));
  }

  return dates;
}

DateTime stringToUtcDate(String dateString) {
  // Parse the string into a local DateTime object
  final localDate = DateFormat('dd-MMM-yyyy').parse(dateString);

  // Convert the local DateTime to UTC
  return localDate.toUtc();
}
