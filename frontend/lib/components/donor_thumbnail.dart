import 'package:flutter/material.dart';

class DonorThumbnail extends StatefulWidget {
  final String donorName;
  final Future<String> donorURL;
  final String donorAddress;

  const DonorThumbnail(
      {Key? key,
      required this.donorName,
      required this.donorURL,
      required this.donorAddress})
      : super(key: key);

  @override
  _DonorThumbnailState createState() => _DonorThumbnailState();
}

class _DonorThumbnailState extends State<DonorThumbnail> {
  String donorURL = "";

  void donorDetails(context) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return RestaurantScreen(restaurantName: donorName);
    // }));
  }

  void getURL() async {
    donorURL = await widget.donorURL;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getURL();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Container(
        width: 120,
        child: GestureDetector(
            onTap: () => donorDetails(context),
            child: Column(
              children: [
                donorURL == ""
                    ? CircleAvatar(
                        radius: 50.0,
                        child: Icon(Icons.more_horiz),
                      )
                    : CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(donorURL),
                      ),
                Text(
                  widget.donorName,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.donorAddress,
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }
}
