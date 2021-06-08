import 'package:drp_basket_app/components/avatar.dart';
import 'package:drp_basket_app/components/long_button.dart';
import 'package:drp_basket_app/locator.dart';
import 'package:drp_basket_app/view_controllers/image_picker_controller.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/view_controllers/validator_controller.dart';
import 'package:drp_basket_app/views/auth/auth_view_interface.dart';
import 'package:drp_basket_app/views/home_page.dart';
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
  late String name;
  late String contactNumber;

  void upload() async {
    uploadedImage = await locator<ImagePickerController>().pickImage();
    setState(() {
    });
  }

  void submit() {
    if (_formKey.currentState!.validate() && uploadedImage) {
      locator<UserController>().uploadUserInformation(this, widget.userType, name, contactNumber);
    }
    else if (!uploadedImage) {
      updateUIAuthFail("Image not uploaded", "Please upload an image");
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
            onPressed: () => Navigator.pop(context),
          ),
        ]).show();
  }

  @override
  void updateUISuccess() {
    Navigator.pushNamed(context, HomePage.id);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("User Information"),
        backgroundColor: _colorTheme,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Avatar(
                      uploaded: uploadedImage,
                      onTap: upload,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) =>
                                ValidatorController.validateName(value!),
                            decoration: InputDecoration(
                              labelText: 'Enter your name',
                            ),
                            onChanged: (value) => name = value,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            validator: (value) =>
                                ValidatorController.validateContactNumber(value!),
                            decoration: InputDecoration(
                              labelText: 'Enter your contact number',
                            ),
                            onChanged: (value) => contactNumber = value,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
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
          ],
        ),
      ),
    );
  }
}
