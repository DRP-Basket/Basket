import 'package:drp_basket_app/firebase_controllers/firebase_auth_controller.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_controller.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_controller.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupServices() async {
  await Firebase.initializeApp();
  locator.registerSingleton<UserController>(UserController(
      FirebaseAuthController(),
      FirebaseStorageController(),
      FirebaseFirestoreController()));
  locator.registerSingleton<ImagePickerController>(ImagePickerController());
}
