import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerController {
  late File _image;
  final _picker = ImagePicker();
  late String path;

  Future<bool> pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      path = pickedFile.path;
      return true;
    }
    return false;
  }

  File getImage() {
    return _image;
  }
}