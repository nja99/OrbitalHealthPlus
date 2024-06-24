import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  String to24HourString() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }

  String to12HourString() {
    final dt = DateTime(1, 1, 1, hour, minute);
    return DateFormat('h:mm a').format(dt);
  }

  static TimeOfDay toTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format, expected HH:mm');
    }
    return TimeOfDay(hour:int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
