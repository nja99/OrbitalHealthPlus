// services/appointment_service.dart
import 'package:healthsphere/assets/model/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Appointment>> getAppointments() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appointments')
          .get();

      return snapshot.docs.map((doc) {
        try {
          return Appointment.fromMap(doc.id, doc.data());
        } catch (e) {
          print('Error parsing appointment: $e');
          return null;
        }
      }).whereType<Appointment>().toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }


  Future<void> createAppointment(Appointment appointment) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _firestore.collection('users').doc(user.uid).collection('appointments').add({
    'donationType': appointment.donationType,
    'dateTime': appointment.dateTime != null ? Timestamp.fromDate(appointment.dateTime!) : null,
    'city': appointment.city,
    'facility': appointment.facility,
    'location': appointment.location != null 
      ? GeoPoint(appointment.location!.latitude, appointment.location!.longitude)
      : null,
  });
}

  Future<void> cancelAppointment(String appointmentId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    } catch (e) {
      print('Error cancelling appointment: $e');
    }
  }
}