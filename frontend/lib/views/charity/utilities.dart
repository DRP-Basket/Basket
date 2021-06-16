import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/charity/charity_donor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimePicker extends StatefulWidget {
  final TextEditingController _dateController;

  DateTimePicker(this._dateController);

  @override
  _DateTimePickerState createState() => _DateTimePickerState(_dateController);
}

class _DateTimePickerState extends State<DateTimePicker> {
  String date = "Choose Event Date";

  final TextEditingController _dateController;

  _DateTimePickerState(this._dateController);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 20),
                    Text('$date'),
                  ],
                ),
              ),
              onPressed: () {
                DatePicker.showDatePicker(
                  context,
                  onConfirm: (DateTime d) {
                    date =
                        '${d.year}-${d.month < 10 ? "0${d.month}" : d.month}-${d.day < 10 ? "0${d.day}" : d.day}';
                    _dateController.text = date;
                    setState(() {});
                  },
                );
              }),
        ],
      ),
    );
  }
}

class DonorPageUtilities {
  static Widget introRow(DonorModel donorModel) {
    return Row(
      children: [
        Spacer(),
        Expanded(
          flex: 30,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: CircleAvatar(
                backgroundImage: donorModel.image,
                radius: 75,
              ),
            ),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 35,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donorModel.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${donorModel.address}',
                    style: TextStyle(
                      color: third_color,
                    ),
                  ),
                ),
                Text(
                  '${donorModel.contactNumber}',
                  style: TextStyle(
                    color: third_color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String getTimeString(Timestamp time) {
    List<String> timeStrings =
        DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch)
            .toString()
            .split(':');
    return timeStrings[0] + ':' + timeStrings[1];
  }
}
