import 'package:flutter/material.dart';

import '../../enums/attendance_description.dart';
import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';
import '../custom_dialog.dart';

class OnSwipeRightAttendance extends StatelessWidget {
  const OnSwipeRightAttendance({
    super.key,
    required this.filteredList,
    required this.index,
    required this.addNotSubmittedAttendance,
    required this.valueStatus,
    required this.attendancesList,
    required this.attendanceDoesNotExist,
    required this.onChanged,
  });

  final List<TrainingDateResponseModel> filteredList;
  final int index;
  final void Function() addNotSubmittedAttendance;
  final void Function(String? newValue) onChanged;
  final bool attendanceDoesNotExist;
  final String valueStatus;
  final List<AttendanceResponseModel> attendancesList;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title:
          "${filteredList[index].userModel!.name} ${filteredList[index].userModel!.surname} ${filteredList[index].userModel!.userId}",
      message: "${filteredList[index].trainingModel!.trainingType}",
      children: [
        if (attendanceDoesNotExist) ...{
          DropdownButton<String>(
            onChanged: onChanged,
            hint: const Text("Reason"),
            value: valueStatus.isNotEmpty ? valueStatus : null,
            items: <String>[
              AttendanceDescription.Late,
              AttendanceDescription.Sick
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextButton(
            onPressed: addNotSubmittedAttendance,
            child: const Text("Ok"),
          ),
        }
      ],
    );
  }
}
