class Donation{
  
  String donationID;
  final String donorID;

  Donation(this.donationID, this.donorID);

  static Donation buildFromMap(String id, Map<String, dynamic> donation) {
    var donorID = donation['donor_id'];
    return Donation(id, donorID);
  }

}