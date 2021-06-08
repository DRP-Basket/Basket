import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final onTap;
  final bool uploaded;

  const Avatar({Key? key, required this.onTap, required this.uploaded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: !uploaded
            ? CircleAvatar(
                radius: 50.0,
                child: Icon(Icons.photo_camera),
              )
            : CircleAvatar(
                radius: 50.0,
                backgroundImage: FileImage(
                  locator<ImagePickerController>().getImage(),
                ),
              ),
      ),
    );
  }
}
