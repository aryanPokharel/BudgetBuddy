import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TimeOfDay parseStringToTimeOfDay(String timeOfDayString) {
  final regex = RegExp(r'TimeOfDay\((\d+):(\d+)\)');
  final match = regex.firstMatch(timeOfDayString);
  if (match == null || match.groupCount < 2) {
    throw ArgumentError('Invalid TimeOfDay format');
  }

  final hour = int.parse(match.group(1).toString());
  final minute = int.parse(match.group(2).toString());

  return TimeOfDay(hour: hour, minute: minute);
}

String formatTimeOfDay(String time) {
  final now = DateTime.now();

  var timeOfDay = parseStringToTimeOfDay(time);
  final dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat.jm();
  return format.format(dateTime);
}
