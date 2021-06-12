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
    return FormBuilderDateTimePicker(
      style: fieldStyle(),
      name: fieldName,
      inputType: InputType.both,
      decoration: fieldDecor(fieldName, false),
    );
  }

  static addButton(void Function() onPressed, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
      ),
      child: Text(
        label,
        style: FormUtilities.fieldStyle(),
      ),
      onPressed: onPressed,
    );
  }
}
