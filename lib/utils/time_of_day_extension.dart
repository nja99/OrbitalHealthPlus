import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
