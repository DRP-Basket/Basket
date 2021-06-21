import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Widget actionButton(
    {IconData? icon,
    required String label,
    double? fontSize,
    required Color color,
    required void Function() onPressed}) {
  if (icon != null) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label, style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
    );
  } else {
    return ElevatedButton(
      child: Text(label, style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

String formatDateTime(DateTime dateTime,
    {String format: 'EEE, d MMM yyyy, hh:mm aaa'}) {
  DateFormat df = DateFormat(format);
  return df.format(dateTime);
}

Widget loading() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.lightBlueAccent,
    ),
  );
}
