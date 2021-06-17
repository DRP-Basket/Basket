import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/donor/donor_home_page.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class DonorProfilePage extends StatefulWidget {
  static const String id = "DonorProfilePage";

  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  late DonorInformationModel donorInformationModel;

  @override
  Widget build(BuildContext context) {
    donorInformationModel = Provider.of<DonorInformationModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile'),
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        actions: [
          _logOutButton(),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _profileImage(),
              Container(
                child: Column(
                  children: [
                    accountInfo('Name', donorInformationModel.name),
                    accountInfo('Email', donorInformationModel.email),
                    accountInfo(
                        'Contact Number', donorInformationModel.contactNumber),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<ImageProvider> _getImage(
      BuildContext context, DonorInformationModel donorInformationModel) async {
    String downloadUrl;
    try {
      downloadUrl = await locator<UserController>()
          .loadFromStorage(context, donorInformationModel.uid);
    } catch (err) {
      downloadUrl =
          "https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg";
    }
    ImageProvider imageProvider = NetworkImage(downloadUrl);
    donorInformationModel.updateImage(imageProvider);
    return imageProvider;
  }

  Widget accountInfo(String category, String info) {
    return ListTile(
      title: Text(category),
      subtitle: Text(info),
    );
  }

  Widget _logOutButton() {
    return IconButton(
      onPressed: () {
        locator<UserController>().userSignOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false);
      },
      icon: Icon(Icons.logout),
    );
  }

  Widget _profileImage() {
    if (donorInformationModel.imageProvider != null) {
      return CircleAvatar(
        radius: 60,
        foregroundImage: donorInformationModel.imageProvider,
      );
    }
    return FutureBuilder(
      future: _getImage(context, donorInformationModel),
      builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return CircleAvatar(
            radius: 60,
            foregroundImage: snapshot.data,
          );

        if (snapshot.connectionState == ConnectionState.waiting)
          return CircleAvatar(
            child: CircularProgressIndicator(),
          );

        return CircleAvatar();
      },
    );
  }
}
