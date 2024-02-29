import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/widgets/attendance_status.dart';

import '../../models/attendance_model.dart';
import '../../models/trainingDate_model.dart';

class AttendanceInfo extends StatelessWidget {
  const AttendanceInfo({
    super.key,
    required this.training,
    required this.attendancesList,
  });

  final TrainingDateResponseModel training;
  final List<AttendanceResponseModel> attendancesList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${training.trainingModel!.trainingType} ${DateFormat('dd-MM-yyyy').format(training.dates!.toLocal())}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8.0),
                      Text(
                        "${DateFormat('HH:mm').format(training.timeFrom!.toLocal())} - ${DateFormat('HH:mm').format(training.timeTo!.toLocal())}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  AttendanceStatusWidget(
                    attendList: attendancesList,
                    training: training,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            CircleAvatar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: Text(
                "${training.userModel!.name!.substring(0, 1)}${training.userModel!.surname!.substring(0, 1)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
