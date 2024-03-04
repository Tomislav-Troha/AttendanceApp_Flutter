import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/widgets/sumbit_attendance/build_info_text.dart';

import '../../models/trainingDate_model.dart';

class SubmitAttendanceInfo extends StatelessWidget {
  const SubmitAttendanceInfo(
      {super.key, required this.trainingDateResponseModel});

  final TrainingDateResponseModel trainingDateResponseModel;

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      return DateFormat("dd.MM.yyyy").format(date);
    }

    String formatTime(DateTime from, DateTime to) {
      return "${from.toLocal().hour}:${from.toLocal().minute.toString().padLeft(2, '0')} - ${to.toLocal().hour}:${to.toLocal().minute.toString().padLeft(2, '0')}";
    }

    DateTime timeFrom = trainingDateResponseModel.timeFrom!.toLocal();
    DateTime timeTo = trainingDateResponseModel.timeTo!.toLocal();

    return Column(
      children: [
        Stack(
          children: [
            Opacity(
              opacity: 0.9,
              child: Image.asset(
                "assets/images/mark.png",
                color: Colors.black,
                height: 160,
              ),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Image.asset(
                  "assets/images/mark.png",
                  height: 150,
                ),
              ),
            )
          ],
        ),
        Card(
          color: Theme.of(context).colorScheme.primary,
          elevation: 4,
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoText(
                  context: context,
                  text: trainingDateResponseModel.trainingModel!.trainingType!,
                  scale: 2.0,
                ),
                const Icon(
                  Icons.sports_baseball_outlined,
                  color: Colors.deepOrangeAccent,
                  size: 40,
                )
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoText(
                  context: context,
                  text: formatDate(trainingDateResponseModel.dates!.toLocal()),
                  scale: 2.0,
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.deepOrangeAccent,
                  size: 40,
                )
              ],
            ),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.primary,
          elevation: 4,
          margin: const EdgeInsets.all(20),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoText(
                  context: context,
                  text: formatTime(timeFrom, timeTo),
                  scale: 1.4,
                ),
                Icon(
                  Icons.timelapse_outlined,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 40,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
