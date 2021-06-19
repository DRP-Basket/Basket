class Receiver {
  final String name;
  final String contact;
  final String location;
  final DateTime? lastClaimed;

  Receiver(this.name, this.contact, this.location, {this.lastClaimed: null});

  static Receiver buildFromMap(Map<String, dynamic> rm) {
    var lastClaimed = rm['last_claimed'] != null ? rm['last_claimed'].toDate() : null;
    return Receiver(rm['name'], rm['contact'], rm['location'],
        lastClaimed: lastClaimed);
  }

}
