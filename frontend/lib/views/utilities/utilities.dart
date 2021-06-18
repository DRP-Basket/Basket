import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

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
