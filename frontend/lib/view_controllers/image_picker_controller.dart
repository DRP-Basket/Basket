import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerController {
  late File _image;
  final _picker = ImagePicker();
  late String path;
  bool _uploadedImage = false;

  Future<bool> pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      path = pickedFile.path;
      _uploadedImage = true;
      return true;
    }
    return false;
  }

  File getImage() {
    return _image;
  }

  bool uploadedImage() {
    return _uploadedImage;
  }
}