import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            // Description
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: 'Contact',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Add Contact"),
              onPressed: () {
                _addToFireBase();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  final _fireStore = FirebaseFirestore.instance;

  Future<void> _addToFireBase() async {
    DocumentSnapshot ds = await _fireStore.collection("charities").doc(
        "ex-charity").get();

    List contactList = (ds.data() as Map<String,
        dynamic>)["contact_list"] as List;

    String name = _titleController.text;
    String contactNumber = _descController.text;

    print(name);
    print(contactNumber);
    print(contactList);

    QuerySnapshot foo = await
    _fireStore.collection("receivers").where('name', isEqualTo: name).where(
        'contact_number', isEqualTo: contactNumber).get();

    String uid = foo.docs.single.id;

    contactList.add({
      "Name": name.trim(),
      "Contact": contactNumber.trim(),
      "uid": uid
    });
    
    _fireStore.collection("charities").doc("ex-charity").update({
      "contact_list": contactList
    });
  }

}
