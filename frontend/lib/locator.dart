import 'package:drp_basket_app/firebase_controllers/firebase_auth_controller.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_auth_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_controller.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_controller.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/gps_controllers/geolocator_controller.dart';
import 'package:drp_basket_app/view_controllers/receiver_controller.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'gps_controllers/geocoding_controller.dart';

final locator = GetIt.instance;

Future<void> setupServices() async {
  await Firebase.initializeApp();
  locator.registerSingleton<FirebaseAuthInterface>(FirebaseAuthController());
  locator
      .registerSingleton<FirebaseStorageInterface>(FirebaseStorageController());
  locator.registerSingleton<FirebaseFirestoreInterface>(
      FirebaseFirestoreController());
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<ReceiverController>(ReceiverController());
  locator.registerSingleton<ImagePickerController>(ImagePickerController());
  locator.registerSingleton<GeoLocatorController>(GeoLocatorController());
  locator.registerSingleton<GeoCodingController>(GeoCodingController());
}
