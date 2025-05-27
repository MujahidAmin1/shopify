import 'package:flutter/material.dart';

Future<void> showLogoutConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Logout"),
      content: const Text("Are you sure you want to log out?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirm(); // Perform the logout
          },
          child: const Text("Logout"),
        ),
      ],
    ),
  );
}
