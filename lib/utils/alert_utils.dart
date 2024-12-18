import 'package:flutter/material.dart';

class AlertUtils {
  // Displays a snackbar with a custom message
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Displays an alert dialog with a custom message
  static void showAlertDialog(
      {required BuildContext context,
      String title = '',
      required String message,
      required String buttonName}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title != '' ? Text(title) : null,
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              buttonName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
