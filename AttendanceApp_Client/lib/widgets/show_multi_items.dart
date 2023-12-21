import 'package:flutter/material.dart';
import 'package:swimming_app_client/widgets/custom_dialog.dart';
import 'package:swimming_app_client/widgets/multi_select_chip.dart';

class ShowMultiItems {
  static void showMultiMembers<T>(
      BuildContext context,
      List<T> userList,
      Function(List<T>) onSelectionComplete,
      Widget Function(T) labelBuilder) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          message: "",
          title: "Pick a member",
          children: [
            MultiSelectChip(
              reportList: userList,
              onSelectionChanged: onSelectionComplete,
              labelBuilder: labelBuilder,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    "Done!",
                    textScaleFactor: 1.4,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }
}
