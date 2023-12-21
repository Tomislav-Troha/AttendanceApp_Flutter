import 'package:flutter/material.dart';

import 'custom_dialog.dart';
import 'multi_select_chip.dart';

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
          title: "Odaberi člana",
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
                    "Ok",
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
