import 'package:flutter/material.dart';
import 'package:swimming_app_client/widgets/custom_dialog.dart';
import 'package:swimming_app_client/widgets/multi_select_chip.dart';

class ShowMultiItems {
  static void showMultiMembers<T>(
      BuildContext context,
      List<T> userList,
      Function(List<T>) onSelectionComplete,
      Widget Function(T) labelBuilder,
      List<T>? alreadySelectedChips) async {
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
              alreadySelected: alreadySelectedChips,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    "Done!",
                    textScaleFactor: 1.4,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
