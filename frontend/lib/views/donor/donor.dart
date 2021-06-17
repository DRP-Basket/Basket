class Donor {
  final String uid;
  final String name;
  final String email;
  final String contact;
  final String address;

  Donor(this.uid, this.name, this.email, this.contact, this.address);

  static var ErrorDonor = Donor('-1', 'Donor Can\'t Be Found', '-', '-', '-');

  //TODO change to correct fields corresponding to firestore
  static Donor buildFromMap(String donorID, Object? donorMap) {
    return Donor(donorID, 'WY TEST DONOR', 'tee.weiyi22@gmail.com', '0123456', 'Kensington');
  }
}