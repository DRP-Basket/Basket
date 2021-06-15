import 'package:drp_basket_app/user_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_storage_interface.dart';
import 'dart:io';

class FirebaseStorageController implements FirebaseStorageInterface {
  final _storage = FirebaseStorage.instance;

  void uploadFile(String destination, File file) {
    try {
      final ref = _storage.ref(destination);
      ref.putFile(file);
    } catch (exception) {
      print(exception);
    }
  }

  Future<String> getImageUrl(UserType userType, String uid) async {
    String path = cloudProfileFilePath[userType]! + uid;
    var storageRef = _storage.ref(path);
    String url;
    try {
      url = await storageRef.getDownloadURL();
    } catch (err) {
      url =
          "https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg";
    }
    return url;
  }

  Future<String> loadFromStorage(String image) {
    return _storage.ref(image).getDownloadURL();
  }
}
