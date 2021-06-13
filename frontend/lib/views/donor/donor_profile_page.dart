import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class DonorProfilePage extends StatelessWidget {
  static const String id = "DonorProfilePage";

  @override
  Widget build(BuildContext context) {
    var curUser = locator<UserController>().curUser()!;
    var snapshot = locator<UserController>().donorFromID(curUser.uid);
    return Container(
        padding: EdgeInsets.all(20),
        child: Flexible(
          child: Column(
            children: [
              FutureBuilder(
                  future: _getImage(context, curUser.uid),
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
                  }),
              FutureBuilder(
                  future: snapshot,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data()! as Map<String, dynamic>;
                      return Container(
                        child: Column(
                          children: [
                            accountInfo('Name', data['name']),
                            accountInfo('Email', curUser.email!),
                            accountInfo(
                                'Contact Number', data['contact_number']),
                          ],
                        ),
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ));
  }

  Future<ImageProvider> _getImage(BuildContext context, String image) async {
    ImageProvider m = NetworkImage(
        'https://i.pinimg.com/originals/59/54/b4/5954b408c66525ad932faa693a647e3f.jpg');
    try {
      await locator<UserController>()
          .loadFromStorage(context, image)
          .then((downloadUrl) {
        m = NetworkImage(
          downloadUrl.toString(),
        );
      });
    } catch (err) {
      print("Error loading picture");
    }
    return m;
  }

  Widget accountInfo(String category, String info) {
    return ListTile(
      title: Text(category),
      subtitle: Text(info),
    );
  }
}
