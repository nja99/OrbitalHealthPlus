import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Appointment {
  final String id;
  final String donationType;
  final DateTime? dateTime;
  final String city;
  final String facility;
  final LatLng? location;

  Appointment({
    required this.id,
    required this.donationType,
    this.dateTime,
    required this.city,
    required this.facility,
    this.location,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      donationType: data['donationType'] ?? 'Unknown',
      dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : null,
      city: data['city'] ?? 'Unknown',
      facility: data['facility'] ?? 'Unknown',
      location: data['location'] != null
          ? LatLng((data['location'] as GeoPoint).latitude, (data['location'] as GeoPoint).longitude)
          : null,
    );
  }
}