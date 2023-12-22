import 'package:flutter/material.dart';
import 'package:swimming_app_client/Widgets/custom_dialog.dart';

import '../../models/trainingDate_model.dart';

class OnDeleteAttendance extends StatelessWidget {
  const OnDeleteAttendance({
    super.key,
    required this.deleteAttendance,
    required this.item,
  });

  final void Function() deleteAttendance;
  final TrainingDateResponseModel item;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Are you sure?",
      message: "",
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.center,
            child: TextButton.icon(
              style: ButtonStyle(iconSize: MaterialStateProperty.all(35)),
              icon: const Icon(Icons.delete_forever),
              onPressed: deleteAttendance,
              label: const Text(
                "Yes",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        )
      ],
    );
  }
}
