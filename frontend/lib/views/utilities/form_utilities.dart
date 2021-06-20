import 'package:drp_basket_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormUtilities {
  static InputDecoration fieldDecor(String fieldName, bool optional) {
    return InputDecoration(
      labelText: fieldName + (optional ? ' (optional)' : ' *'),
    );
  }

  static TextStyle fieldStyle() => TextStyle(
        fontSize: 20,
      );

  static Widget textField(String fieldName, {bool optional: false}) {
    return FormBuilderTextField(
      style: fieldStyle(),
      name: fieldName,
      decoration: fieldDecor(fieldName, optional),
      validator: (value) {
        if (!optional && (value == null || value.isEmpty)) {
          return 'Please enter ${fieldName.toLowerCase()}';
        }
        return null;
      },
    );
  }

  static Widget dateTimePicker(String fieldName) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          primaryColorDark: third_color,
          accentColor: third_color,
        ),
        dialogBackgroundColor: Colors.white,
      ),
      child: Builder(
        builder: (context) => FormBuilderDateTimePicker(
          style: fieldStyle(),
          firstDate: DateTime.now(),
          name: fieldName,
          inputType: InputType.both,
          decoration: fieldDecor(fieldName, false),
          validator: (value) {
            if (value == null) {
              return 'Please choose date and time';
            }
          },
        ),
      ),
    );
  }

  static addButton(void Function() onPressed, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        primary: secondary_color,
      ),
      child: Text(
        label,
        style: FormUtilities.fieldStyle(),
      ),
      onPressed: onPressed,
    );
  }
}
