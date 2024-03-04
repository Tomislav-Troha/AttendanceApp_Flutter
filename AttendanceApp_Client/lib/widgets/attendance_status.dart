import 'package:flutter/material.dart';
import 'package:swimming_app_client/models/attendance_model.dart';
import 'package:swimming_app_client/widgets/training_time_utils.dart';

import '../enums/attendance_description.dart';
import '../models/trainingDate_model.dart';

class AttendanceStatusWidget extends StatelessWidget {
  const AttendanceStatusWidget({
    Key? key,
    required this.attendList,
    required this.training,
    this.height,
    this.width,
    this.fontSize = 14,
  }) : super(key: key);

  final List<AttendanceResponseModel>? attendList;
  final TrainingDateResponseModel training;
  final double? width;
  final double? height;
  final double? fontSize;

  String? _getAttendanceText() {
    for (var element in attendList!) {
      int? trainingDateId = element.trainingDateModel?.iD_TrainingDate;
      String? attDesc = element.attDesc;

      if (trainingDateId == training.iD_TrainingDate) {
        return attDesc;
      }
    }

    Duration? waitTime = TrainingTimeUtils.calculateWaitTime(
        training.dates!.toLocal(), training.timeFrom!);
    if (waitTime != null) {
      return "Starts in ${waitTime.inHours} hours";
    }

    return 'Expired';
  }

  Color _getStatusColor(String attendanceText, BuildContext context) {
    if (attendanceText == AttendanceDescription.Accepted) {
      return Colors.green;
    } else if (attendanceText == AttendanceDescription.NotAccepted) {
      return Colors.red;
    } else if (attendanceText == AttendanceDescription.Late) {
      return Colors.orange;
    } else if (attendanceText == AttendanceDescription.Sick) {
      return Colors.purple;
    } else if (attendanceText.contains("Starts in")) {
      return Colors.greenAccent;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? attendanceText = _getAttendanceText();
    Color statusColor = _getStatusColor(attendanceText!, context);
    double width = this.width ?? 180;
    double height = this.height ?? 35;
    double fontSize = this.fontSize ?? 14;

    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: statusColor.withOpacity(0.2),
      ),
      child: Text(
        attendanceText,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: statusColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
