import 'package:google_maps_flutter/google_maps_flutter.dart';

class Clinic {
  final String name;
  final String address;
  final String details;
  final LatLng location;

  Clinic({
    required this.name,
    required this.address,
    required this.details,
    required this.location,
  });
}

final List<Clinic> clinics = [
  Clinic(
    name: "Clinic A",
    address: "123 Main St",
    details: "hello",
    location: LatLng(1.290270, 103.851959),
  ),
  Clinic(
    name: "Clinic B",
    address: "456 Sec St",
    details: "hello",
    location: LatLng(1.352083, 103.819836),
  ),
  // Add more clinics as needed
];