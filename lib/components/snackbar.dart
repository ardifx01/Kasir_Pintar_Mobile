// lib/utils/snackbar_util.dart
import 'package:flutter/material.dart';

enum SnackBarType { success, warning, error, info }

void showCustomSnackBar(
    BuildContext context, String message, SnackBarType type) {
  final color = _getSnackBarColor(type);

  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'TUTUP',
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Color _getSnackBarColor(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return Colors.green;
    case SnackBarType.warning:
      return Colors.orange;
    case SnackBarType.error:
      return Colors.red;
    case SnackBarType.info:
    default:
      return Colors.blue;
  }
}
