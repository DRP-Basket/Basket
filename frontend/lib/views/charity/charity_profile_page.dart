import 'package:drp_basket_app/firebase_controllers/firebase_firestore_interface.dart';
import 'package:drp_basket_app/firebase_controllers/firebase_storage_interface.dart';
import 'package:drp_basket_app/user_type.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/charity/events/charity_events_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class CharityProfilePage extends StatefulWidget {
  static const String id = "CharityProfilePage";

  CharityProfilePage({Key? key}) : super(key: key);

  @override
  _CharityProfilePageState createState() => _CharityProfilePageState();
}

class _CharityProfilePageState extends State<CharityProfilePage> {
  late CharityInformationModel charityInformationModel;

  @override
  Widget build(BuildContext context) {
    charityInformationModel = Provider.of<CharityInformationModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          charityInformationModel.imageProvider == null
              ? FutureBuilder(
                  future: _getImage(),
                  builder: (BuildContext context,
                      AsyncSnapshot<ImageProvider> snapshot) {
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
                  })
              : CircleAvatar(
                  radius: 60,
                  foregroundImage: charityInformationModel.imageProvider,
                ),
          Container(
            child: Column(
              children: [
                accountInfo('Name', charityInformationModel.name),
                accountInfo('Email', charityInformationModel.email),
                accountInfo(
                    'Contact Number', charityInformationModel.contactNumber),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<ImageProvider> _getImage() async {
    String downloadUrl;
    try {
      downloadUrl = await locator<FirebaseStorageInterface>()
          .getImageUrl(UserType.CHARITY, charityInformationModel.uid);
    } catch (err) {
      downloadUrl =
          "https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg";
    }
    ImageProvider imageProvider = NetworkImage(downloadUrl);
    charityInformationModel.updateImage(imageProvider);
    return imageProvider;
  }

  Widget accountInfo(String category, String info) {
    return ListTile(
      title: Text(category),
      subtitle: Text(info),
    );
  }
}
