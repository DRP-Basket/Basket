import 'package:drp_basket_app/views/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import 'donation.dart';

class DonationForm extends StatefulWidget {
  final Request? request;

  const DonationForm({Key? key, Request? this.request}) : super(key: key);

  @override
  _DonationFormState createState() => _DonationFormState(request);
}
// TODO : customise header : 'Add Donation' vs 'Making a Donation for <charityName>'

class _DonationFormState extends State<DonationForm> {
  final Request? request;

  _DonationFormState(this.request);

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
          title: Text(
              '${request == null ? 'Adding' : 'Responding with'} new donation'),
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
                          _confirmTap();
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

  void _confirmTap() {
    Donation donation = Donation.addNewDonation(
      items: _foodItemsEditingController.text,
      portions: _portionNumberEditingController.text,
      options: _dietaryOptionsEditingController.text,
      collectDate: date,
      collectTime: time?.format(context),
      charityID: request?.charityID,
    );
    request?.respond(donation);
  }
}
