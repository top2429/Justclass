import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(BuildContext context, {String message, Color bgColor}) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      elevation: 1,
      backgroundColor: bgColor == null ? Colors.white.withOpacity(0.9) : bgColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message == null ? "Something went wrong!" : message,
        style: const TextStyle(color: Colors.black),
      ),
    ));
  }
}
