  import 'package:flutter/material.dart';

Widget actionButton(
      {IconData? icon,
      required String label,
      required Color color,
      required void Function() onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
    );
  }