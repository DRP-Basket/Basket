import 'package:drp_basket_app/components/avatar.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/view_controllers/validator_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:drp_basket_app/views/charity/events/charity_events_page.dart';
import 'package:drp_basket_app/views/donor/donor_main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../user_type.dart';

class RegisterInformationScreen extends StatefulWidget {
  final UserType userType;

  const RegisterInformationScreen({Key? key, required this.userType})
      : super(key: key);

  @override
  _RegisterInformationScreenState createState() =>
      _RegisterInformationScreenState();
}

class _RegisterInformationScreenState extends State<RegisterInformationScreen>
    implements AuthViewInterface {
  late Color _colorTheme;
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool uploadedImage = false;

  String name = "";
  String contactNumber = "";
  String address = "";
  String description = "";

  void upload() async {
    uploadedImage = await locator<ImagePickerController>().pickImage();
    setState(() {});
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate() && uploadedImage) {
      if (widget.userType == UserType.DONOR) {
        await locator<UserController>().uploadUserInformation(
            this, widget.userType, name, contactNumber,
            address: address);
      } else {
        await locator<UserController>().uploadUserInformation(
            this, widget.userType, name, contactNumber,
            description: description);
      }
    } else if (!uploadedImage) {
      updateUIAuthFail("Image not uploaded", "Please upload an image");
      // if (widget.userType == UserType.RECEIVER) {
      //   locator<UserController>().uploadUserInformation(
      //       this, widget.userType, name, contactNumber,
      //       containsImage: false);
      // } else {
      //   updateUIAuthFail("Image not uploaded", "Please upload an image");
      // }
    }
  }

  @override
  void updateUILoading() {
    setState(() {
      showSpinner = true;
    });
  }

  @override
  void resetSpinner() {
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void updateUIAuthFail(String title, String errmsg) {
    Alert(
        context: context,
        title: title,
        desc: errmsg,
        type: AlertType.warning,
        buttons: [
          DialogButton(
            child: Text(
              "Try Again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.deepOrange,
            onPressed: () => Navigator.pop(context),
          ),
        ]).show();
  }

  @override
  void updateUISuccess() {
    widget.userType == UserType.CHARITY
        ? Navigator.pushNamedAndRemoveUntil(
            context, CharityEventsPage.id, (route) => false)
        : Navigator.pushNamedAndRemoveUntil(
            context, DonorMain.id, (route) => false);
  }

  @override
  void initState() {
    _colorTheme = userColorTheme[widget.userType]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${userTypeString[widget.userType]} Information"),
        backgroundColor: _colorTheme,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24,
              top: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Avatar(
                    uploaded: uploadedImage,
                    onTap: upload,
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    children: [
                      Text(
                        "All fields are required",
                        style: TextStyle(
                          color: Colors.red[800],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.5,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) =>
                              ValidatorController.validateName(value!),
                          decoration: _getInputDecoration("Name"),
                          onChanged: (value) => name = value,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (value) =>
                              ValidatorController.validateContactNumber(value!),
                          decoration: _getInputDecoration("Contact Number"),
                          onChanged: (value) => contactNumber = value,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        widget.userType == UserType.DONOR
                            ? TextFormField(
                                validator: (value) =>
                                    ValidatorController.validateAddress(value!),
                                decoration: _getInputDecoration("Address"),
                                onChanged: (value) => address = value,
                              )
                            : TextFormField(
                                validator: (value) =>
                                    ValidatorController.validateDescription(
                                        value!),
                                decoration: _getInputDecoration("Description"),
                                onChanged: (value) => description = value,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  LongButton(
                    text: "Submit",
                    onPressed: submit,
                    backgroundColor: _colorTheme,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[250],
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondary_color, width: 2.0),
      ),
    );
  }
}
