import 'package:flutter/material.dart';

class AppMessage {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showSuccessMessage({
    required String message,
    int? duration = 2,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: Duration(seconds: duration!),
        ),
      );
    }
  }

  static void showErrorMessage({
    String? message = "",
    int? duration = 2,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: Duration(seconds: duration!),
        ),
      );
    }
  }
}
