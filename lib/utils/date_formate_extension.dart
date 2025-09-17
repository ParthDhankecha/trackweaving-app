import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get ddmmyyFormat {
    return DateFormat('dd-MMM-yyyy').format(this);
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
