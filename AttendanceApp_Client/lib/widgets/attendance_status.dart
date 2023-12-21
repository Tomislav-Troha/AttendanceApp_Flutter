import 'package:flutter/material.dart';
import 'package:swimming_app_client/models/attendance_model.dart';

import '../enums/attendance_description.dart';

class AttendanceStatusWidget extends StatelessWidget {
  final int index;
  final List<AttendanceResponseModel>? attendList;
  final List list;
  final double? width;
  final double? height;
  final double? fontSize;

  const AttendanceStatusWidget({
    Key? key,
    required this.index,
    required this.attendList,
    required this.list,
    this.height,
    this.width,
    this.fontSize = 14,
  }) : super(key: key);

  String? _getAttendanceText() {
    for (var element in attendList!) {
      int? trainingDateId = element.trainingDateModel?.iD_TrainingDate;
      String? attDesc = element.attDesc;

      if (trainingDateId == list[index].iD_TrainingDate) {
        return attDesc;
      }
    }
    return 'Još nije zabilježen';
  }

  Color _getStatusColor(String attendanceText) {
    if (attendanceText == AttendanceDescription.Accepted) {
      return Colors.green;
    } else if (attendanceText == AttendanceDescription.NotAccepted) {
      return Colors.red;
    } else if (attendanceText == AttendanceDescription.Late) {
      return Colors.orange;
    } else if (attendanceText == AttendanceDescription.Sick) {
      return Colors.purple;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? attendanceText = _getAttendanceText();
    Color statusColor = _getStatusColor(attendanceText!);
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
