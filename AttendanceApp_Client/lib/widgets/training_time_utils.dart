import 'package:flutter/material.dart';

class TrainingTimeUtils {
  static bool isTrainingInProgress(DateTime trainingDate,
      TimeOfDay trainingTimeFrom, TimeOfDay trainingTimeTo) {
    final now = DateTime.now().toLocal();
    final trainingStart = DateTime(trainingDate.year, trainingDate.month,
            trainingDate.day, trainingTimeFrom.hour, trainingTimeFrom.minute)
        .toLocal();
    final trainingEnd = DateTime(trainingDate.year, trainingDate.month,
            trainingDate.day, trainingTimeTo.hour, trainingTimeTo.minute)
        .toLocal();

    if (now.isAfter(trainingStart) && now.isBefore(trainingEnd)) {
      return true;
    } else {
      return false;
    }
  }

  static bool hasTrainingEnded(
      DateTime trainingDate, TimeOfDay trainingTimeTo) {
    final now = DateTime.now().toLocal();
    final trainingEnd = DateTime(
      trainingDate.year,
      trainingDate.month,
      trainingDate.day,
      trainingTimeTo.hour,
      trainingTimeTo.minute,
    ).toLocal();

    if (now.isAfter(trainingEnd)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTrainingScheduled(DateTime trainingDate,
      TimeOfDay trainingTimeFrom, TimeOfDay trainingTimeTo) {
    final now = DateTime.now().toLocal();
    final trainingStart = DateTime(trainingDate.year, trainingDate.month,
            trainingDate.day, trainingTimeFrom.hour, trainingTimeFrom.minute)
        .toLocal();

    if (now.isBefore(trainingStart)) {
      return true;
    } else {
      return false;
    }
  }

  static bool isUserLateForAttendance(
      DateTime trainingDate, TimeOfDay trainingTimeFrom) {
    final now = DateTime.now().toLocal();
    final trainingStart = DateTime(trainingDate.year, trainingDate.month,
            trainingDate.day, trainingTimeFrom.hour, trainingTimeFrom.minute)
        .toLocal();

    if (now.isAfter(trainingStart)) {
      return true;
    } else {
      return false;
    }
  }

  static Map<String, int> calculateLateTime(
      DateTime trainingDate, TimeOfDay trainingTimeTo) {
    final now = DateTime.now().toLocal();
    final trainingEnd = DateTime(trainingDate.year, trainingDate.month,
            trainingDate.day, trainingTimeTo.hour, trainingTimeTo.minute)
        .toLocal();

    if (now.isAfter(trainingEnd)) {
      final lateDuration = now.difference(trainingEnd);
      final lateDays = lateDuration.inDays;
      final lateHours = lateDuration.inHours % 24;
      final lateMinutes = lateDuration.inMinutes % 60;
      return {
        'days': lateDays,
        'hours': lateHours,
        'minutes': lateMinutes,
      };
    } else {
      return {
        'days': 0,
        'hours': 0,
        'minutes': 0,
      };
    }
  }

  static Duration? calculateWaitTime(DateTime date, DateTime timeFrom) {
    DateTime dateTimeFrom = getDateTimeFrom(date, timeFrom);
    if (dateTimeFrom.isAfter(DateTime.now())) {
      Duration waitTime = dateTimeFrom.difference(DateTime.now());
      return waitTime;
    }
    return null;
  }

  static DateTime getDateTimeFrom(DateTime date, DateTime timeFrom) {
    DateTime dateTimeFrom = DateTime(date.year, date.month, date.day,
        timeFrom.hour, timeFrom.minute, timeFrom.second);

    return dateTimeFrom;
  }
}
