import 'package:flutter/material.dart';

class Donor {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String contactNumber;
  final int donationCount;
  ImageProvider? imageProvider = null;

  Donor(this.uid, this.name, this.email, this.address, this.contactNumber,
      this.donationCount, {this.imageProvider});

  void updateImage(ImageProvider imageProvider) {
    this.imageProvider = imageProvider;
  }

  static Donor buildFromMap(String donorID, Map<String, dynamic> donor) {
    // TODO: image initialisation
    Donor _donor = Donor(donorID, donor['name'], donor['email'],
        donor['address'], donor['contact_number'], donor['donation_count']);
    return _donor;
  }
}
