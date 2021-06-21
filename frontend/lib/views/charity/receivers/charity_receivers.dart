import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/view_controllers/user_controller.dart';
import 'package:drp_basket_app/views/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import 'charity_receiver.dart';
import 'charity_receiver_page.dart';

// Page showing all receiver contacts

class ReceiversList extends StatefulWidget {
  static const String id = "ContactListPage";

  const ReceiversList({Key? key}) : super(key: key);

  @override
  _ReceiversListState createState() => _ReceiversListState();
}

class _ReceiversListState extends State<ReceiversList> {
  FloatingSearchBarController controller = FloatingSearchBarController();

  String searchQuery = '';
  bool sortByLastClaimed = false;
  final String uid = locator<UserController>().curUser()!.uid;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _receivers() {
    return StreamBuilder(
      stream: locator<FirebaseFirestoreInterface>()
          .getContactList(sortByLastClaimed: sortByLastClaimed),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Receivers Yet',
              style: TextStyle(
                color: third_color,
                fontSize: 24,
              ),
            ),
          );
        }
        var receivers = snapshot.data!.docs;
        return ListView(
          padding: EdgeInsets.only(top: 56),
          children: receivers.map((DocumentSnapshot ds) {
            var receiverID = ds.reference.id;
            var receiverMap = ds.data() as Map<String, dynamic>;
            var receiver = Receiver.buildFromMap(receiverMap);
            var relatedToQuery =
                (receiver.name + receiver.contact + receiver.location)
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
            return relatedToQuery
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ReceiverPage(receiverID)));
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receiver.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                _displayLastClaimed(receiver),
                              ],
                            ),
                            Text(receiver.contact),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container();
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      clearQueryOnClose: false,
      autocorrect: false,
      actions: [
        GestureDetector(
          child: FloatingSearchBarAction.searchToClear(),
          onTap: () {
            setState(() {
              controller.clear();
              searchQuery = '';
            });
          },
        ),
        GestureDetector(
          child: Icon(Icons.sort),
          onTap: () {
            setState(() {
              sortByLastClaimed = !sortByLastClaimed;
            });
          },
        ),
      ],
      hint: 'Search for a receiver…',
      body: FloatingSearchBarScrollNotifier(
        child: _receivers(),
      ),
      builder: (BuildContext context, Animation<double> transition) {
        return Container(
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        );
      },
      onQueryChanged: (query) {
        setState(() {
          searchQuery = query;
        });
      },
    );
  }

  Widget _displayLastClaimed(Receiver receiver) {
    DateFormat dateFormat = DateFormat('MMM d, y');
    return Text(
        'Last Claimed: ${receiver.lastClaimed == null ? '-' : dateFormat.format(receiver.lastClaimed!)}');
  }
}
