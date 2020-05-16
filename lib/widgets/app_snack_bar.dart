import 'package:flutter/material.dart';
import 'package:justclass/utils/app_context.dart';

class AppSnackBar {
  static void showError(
    BuildContext context, {
    String message = 'Something went wrong!',
    Color bgColor = Colors.amberAccent,
  }) {
    if (context == null || context != AppContext.last) context = AppContext.last;
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3600),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: const TextStyle(color: Colors.black)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.black54,
          onPressed: Scaffold.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  static void showSuccess(
    BuildContext context, {
    String message = 'Everything is done.',
    Color bgColor = Colors.green,
    Duration delay,
  }) async {
    if (delay != null) await Future.delayed(delay);
    if (context == null || context != AppContext.last) context = AppContext.last;

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: bgColor,
        duration: const Duration(seconds: 3600),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: Scaffold.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }
}
