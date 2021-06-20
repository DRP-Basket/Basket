import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/general/donor.dart';
import 'package:drp_basket_app/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'statistics/donor_stats_screen.dart';

// Donor Profile Page

class DonorProfilePage extends StatefulWidget {
  static const String id = "DonorProfilePage";

  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  late Donor donorInformationModel;

  @override
  Widget build(BuildContext context) {
    donorInformationModel = Provider.of<Donor>(context);

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
                    accountInfo('Address', donorInformationModel.address),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, DonorStatsPage.id),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        elevation: 3,
                        shadowColor: third_color,
                        child: ListTile(
                          title: Text(
                            'Statistics',
                            style: TextStyle(
                              color: third_color,
                            ),
                          ),
                          subtitle: Text('Click for more info'),
                          trailing: Icon(Icons.more_vert),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<ImageProvider> _getImage() async {
    String downloadUrl;
    try {
      downloadUrl = await locator<FirebaseStorageInterface>()
          .getImageUrl(UserType.DONOR, donorInformationModel.uid);
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
      title: Text(
        category,
        style: TextStyle(
          color: third_color,
        ),
      ),
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
      future: _getImage(),
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
