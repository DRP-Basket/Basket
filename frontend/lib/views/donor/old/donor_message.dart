import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drp_basket_app/constants.dart';
import 'package:drp_basket_app/views/donor/old/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DonorMessage extends StatefulWidget {
  const DonorMessage({Key? key}) : super(key: key);

  @override
  _DonorMessageState createState() => _DonorMessageState();
}

class _DonorMessageState extends State<DonorMessage> {
  final TextEditingController _foodItemsEditingController =
      TextEditingController();
  final TextEditingController _portionNumberEditingController =
      TextEditingController();
  final TextEditingController _dietaryOptionsEditingController =
      TextEditingController();

  bool _foodItemsIsEmpty = false;
  bool _portionNumberIsEmpty = false;
  bool _uploading = false;

  TimeOfDay? time = TimeOfDay.now();
  final DateTime dateNow = DateTime.now();
  String date =
      '${DateTime.now().toString().split(" ")[0]} (${DateFormat("EEEE").format(DateTime.now())})';

  @override
  Widget build(BuildContext context) {
    RequestModel _requestModel = Provider.of(context);

    @override
    void dispose() {
      _foodItemsEditingController.dispose();
      _portionNumberEditingController.dispose();
      _dietaryOptionsEditingController.dispose();
      super.dispose();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Respond to ${_requestModel.charityData["name"]}'),
        ),
        body: _uploading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Donation Details",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("* fields are required",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[600],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Food Items *",
                          filled: true,
                          fillColor: Colors.grey[250],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondary_color, width: 2.0),
                          ),
                          hintText: "Bread, Sandwiches, Wraps ...",
                          border: null,
                          errorBorder: _foodItemsIsEmpty
                              ? OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          errorText: _foodItemsIsEmpty
                              ? "Field cannot be empty"
                              : null,
                        ),
                        controller: _foodItemsEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          setState(() {
                            _foodItemsIsEmpty = false;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Number of Portions *",
                          filled: true,
                          fillColor: Colors.grey[250],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondary_color, width: 2.0),
                          ),
                          border: null,
                          errorBorder: _portionNumberIsEmpty
                              ? OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                )
                              : null,
                          errorText: _portionNumberIsEmpty
                              ? "Field cannot be empty"
                              : null,
                        ),
                        controller: _portionNumberEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            _portionNumberIsEmpty = false;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Dietary Options",
                          filled: true,
                          fillColor: Colors.grey[250],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondary_color, width: 2.0),
                          ),
                          hintText: "Nut-free, vegetarian ...",
                          border: null,
                        ),
                        controller: _dietaryOptionsEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Collection Arrangement",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    DropdownButton(
                      value: date,
                      isExpanded: true,
                      style: TextStyle(fontSize: 18, color: third_color),
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      underline: Container(
                        height: 2,
                        color: secondary_color,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          date = newValue!;
                        });
                      },
                      items: [for (var i = 0; i < 5; i += 1) i]
                          .map<DropdownMenuItem<String>>((int value) {
                        DateTime curDate = dateNow.add(Duration(days: value));
                        String displayValue =
                            '${curDate.toString().split(" ")[0]} (${DateFormat("EEEE").format(curDate)})';
                        return DropdownMenuItem<String>(
                          value: displayValue,
                          child: Text(displayValue),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Collect by ${time?.format(context)}',
                          style: TextStyle(
                            fontSize: 20,
                            color: third_color,
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  secondary_color),
                            ),
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (newTime != null) {
                                setState(() {
                                  time = newTime;
                                });
                              }
                            },
                            child: Text("Pick a time"))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                          child: ElevatedButton(
                        onPressed: () {
                          _confirmTap(_requestModel);
                        },
                        child: Text(
                          "Confirm & Send",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primary_color),
                        ),
                      )),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void _confirmTap(RequestModel requestModel) {
    _foodItemsIsEmpty = _foodItemsEditingController.text.isEmpty;
    _portionNumberIsEmpty = _portionNumberEditingController.text.isEmpty;
    if (_foodItemsIsEmpty || _portionNumberIsEmpty) {
      setState(() {});
    } else {
      setState(() {
        _uploading = true;
      });
      final DocumentReference ref = FirebaseFirestore.instance
          .collection("donors")
          .doc(requestModel.curUID)
          .collection("requests")
          .doc(requestModel.reqID);
      ref.update({
        "status": "confirmed",
        "items": _foodItemsEditingController.text,
        "portions": _portionNumberEditingController.text,
        "options": _dietaryOptionsEditingController.text,
        "collect_time": time?.format(context),
        "collect_date": date,
      }).then((value) {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      });
    }
  }
}
