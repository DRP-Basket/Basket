class Donor {
  final String uid;
  final String name;
  final String email;
  final String contact;

  Donor(this.uid, this.name, this.email, this.contact);

  static var ErrorDonor = Donor('-1', 'Donor Can\'t Be Found', '-', '-');
}