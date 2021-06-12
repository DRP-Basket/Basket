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
                    date = '${d.year} - ${d.month} - ${d.day}';
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