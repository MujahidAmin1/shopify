import 'package:flutter/material.dart';

Widget buildIconButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    ),
  );
}
