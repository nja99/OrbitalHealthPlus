import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Appointment {
  final String id;
  final String donationType;
  final DateTime? dateTime;
  final String city;
  final String facility;
  final LatLng? location;
  final String? address;

  Appointment({
    required this.id,
    required this.donationType,
    this.dateTime,
    required this.city,
    required this.facility,
    this.location,
    this.address,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    LatLng? parseLocation(dynamic locationData) {
      if (locationData is GeoPoint) {
        return LatLng(locationData.latitude, locationData.longitude);
      } else if (locationData is Map) {
        final lat = locationData['latitude'];
        final lng = locationData['longitude'];
        if (lat is num && lng is num) {
          return LatLng(lat.toDouble(), lng.toDouble());
        }
      } else if (locationData is String) {
        try {
          final parts = locationData.split(',');
          if (parts.length == 2) {
            return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
          }
        } catch (e) {
          print('Error parsing location string: $locationData');
        }
      }
      return null;
    }

    final locationData = data['location'];
    final LatLng? parsedLocation = parseLocation(locationData);
    
    return Appointment(
      id: id,
      donationType: data['donationType'] ?? 'Unknown',
      dateTime: data['dateTime'] != null ? (data['dateTime'] as Timestamp).toDate() : null,
      city: data['city'] ?? 'Unknown',
      facility: data['facility'] ?? 'Unknown',
      location: parsedLocation,
      address: locationData is String ? locationData : null,
    );
  }
}