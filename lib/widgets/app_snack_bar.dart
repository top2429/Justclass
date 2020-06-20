import 'package:flutter/material.dart';
import 'package:justclass/utils/app_context.dart';

class AppSnackBar {
  static const errorDuration = 30;

  static void showContextError(
    BuildContext context, {
    String message = 'Something went wrong!',
    Color bgColor = Colors.amberAccent,
  }) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: bgColor,
        duration: const Duration(seconds: errorDuration),
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

  static void showError(
    BuildContext context, {
    String message = 'Something went wrong!',
    Color bgColor = Colors.amberAccent,
  }) {
    if (context == null && AppContext.last == null) return;
    if (AppContext.last != null && context != AppContext.last) context = AppContext.last;

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: bgColor,
        duration: const Duration(seconds: errorDuration),
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
    if (context == null && AppContext.last == null) return;
    if (AppContext.last != null && context != AppContext.last) context = AppContext.last;

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: bgColor,
        duration: const Duration(milliseconds: 1500),
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

  static void showClassWarningNotification(
    BuildContext context, {
    String begin,
    String middle,
    String end,
  }) {
    if (context == null && AppContext.last == null) return;
    if (AppContext.last != null && context != AppContext.last) context = AppContext.last;

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: begin),
              TextSpan(text: middle, style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: end),
            ],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        action:
            SnackBarAction(label: 'OK', textColor: Colors.white60, onPressed: Scaffold.of(context).hideCurrentSnackBar),
      ),
    );
  }

  static void showClassInvitationNotification(
    BuildContext context, {
    String begin,
    String middle,
    String end,
  }) {
    if (context == null && AppContext.last == null) return;
    if (AppContext.last != null && context != AppContext.last) context = AppContext.last;

    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: begin),
              TextSpan(text: middle, style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: end),
            ],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        action:
            SnackBarAction(label: 'OK', textColor: Colors.white60, onPressed: Scaffold.of(context).hideCurrentSnackBar),
      ),
    );
  }
}
