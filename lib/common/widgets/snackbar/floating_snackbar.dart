import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

class FloatingSnackbar {
  static void show(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        duration: duration,
      ),
    );
  }
}
