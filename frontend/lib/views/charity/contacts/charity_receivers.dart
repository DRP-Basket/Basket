import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../../locator.dart';
import '../../../firebase_controllers/firebase_firestore_interface.dart';
import '../charity_drawer.dart';
import 'charity_receiver.dart';
import 'charity_receiver_form.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locator<FirebaseFirestoreInterface>()
            .getContactList(sortByLastClaimed: sortByLastClaimed),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else {
            var receivers = snapshot.data!.docs;
            return FloatingSearchBar(
              controller: controller,
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              hint: 'Search for a receiver…',
              body: FloatingSearchBarScrollNotifier(
                child: ListView(
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
                                      builder: (ctx) =>
                                          ReceiverPage(receiverID)));
                            },
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                ),
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
              onSubmitted: (query) {
                setState(() {
                  searchQuery = query;
                });
                controller.close();
              },
            );
          }
        });
  }

  Widget _displayLastClaimed(Receiver receiver) {
    DateFormat dateFormat = DateFormat('MMM d, y');
    return Text(
        'Last Claimed: ${receiver.lastClaimed == null ? '-' : dateFormat.format(receiver.lastClaimed!)}');
  }

// Widget _getSortedReceivers() {
//   if (sortByLastClaimed) {

//   }
// }

}
