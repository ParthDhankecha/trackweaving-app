import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get ddmmyyFormat {
    return DateFormat('dd-MMM-yyyy').format(this);
  }
}
