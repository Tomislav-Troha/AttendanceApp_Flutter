import 'package:flutter/material.dart';

class AppMessage {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showSuccessMessage({
    required String message,
    int? duration = 2,
    BuildContext? context,
  }) {
    final navigatorContext = navigatorKey.currentContext;
    if (navigatorContext != null) {
      ScaffoldMessenger.of(context ?? navigatorContext).clearSnackBars();
      ScaffoldMessenger.of(context ?? navigatorContext).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor:
              Theme.of(context ?? navigatorContext).colorScheme.primary,
          duration: Duration(seconds: duration!),
        ),
      );
    }
  }

  static void showErrorMessage({
    String? message = "",
    int? duration = 2,
    BuildContext? context,
  }) {
    final navigatorContext = navigatorKey.currentContext;
    if (navigatorContext != null) {
      ScaffoldMessenger.of(context ?? navigatorContext).clearSnackBars();
      ScaffoldMessenger.of(context ?? navigatorContext).showSnackBar(
        SnackBar(
          content: Text(
            message!,
            textAlign: TextAlign.center,
            style: Theme.of(context ?? navigatorContext)
                .textTheme
                .titleSmall!
                .copyWith(
                  color:
                      Theme.of(context ?? navigatorContext).colorScheme.onError,
                ),
          ),
          backgroundColor:
              Theme.of(context ?? navigatorContext).colorScheme.error,
          duration: Duration(seconds: duration!),
        ),
      );
    }
  }
}
