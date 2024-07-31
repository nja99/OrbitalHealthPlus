// blood_donation_drives.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BloodDonationDrive {
  final String name;
  final String address;
  final LatLng location;
  final String openingHours;

  BloodDonationDrive({
    required this.name,
    required this.address,
    required this.location,
    required this.openingHours,
  });
}

final List<BloodDonationDrive> bloodDonationDrives = [
  BloodDonationDrive(
    name: "Bloodbank@HSA",
    address: "11 Outram Rd, Singapore 169078",
    location: LatLng(1.2800, 103.8388),
    openingHours: "Mon-Thu: 9am-6pm, Fri: 9am-8pm, Sat: 9am-4pm",
  ),
  BloodDonationDrive(
    name: "Bloodbank@Woodlands",
    address: "900 South Woodlands Drive, #05-07 Woodlands Civic Centre, Singapore 730900",
    location: LatLng(1.4339, 103.7867),
    openingHours: "Mon-Thu: 9am-6pm, Fri: 9am-8pm, Sat: 9am-4pm",
  ),
  // Add 8 more arbitrary blood donation drives here
];