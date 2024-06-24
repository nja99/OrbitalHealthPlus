import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';

class AppointmentFirestoreService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  // Retrieve Collection of Appointments
  CollectionReference get appointmentsCollection {
    String uid = _firebaseAuth.currentUser?.uid ?? '';
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('appointments');
}

// Construct Appointment Data
  Map<String, dynamic> constructAppointmentData({
    required String title,
    required Timestamp dateTime,
    String? location,
    String? description,
    String status = 'Upcoming'
  }) {
    return {
      'title': title,
      'date_time': dateTime,
      'location': location ?? '',
      'notes': description ?? '',
      'status': status
    };
  }

  // CREATE
  Future<void> addAppointment(Map<String, dynamic> data) {
    return appointmentsCollection.add(data);
  }

  // READ
  Stream<QuerySnapshot> readAppointmentStream() {
    return appointmentsCollection
        .orderBy('date_time')
        .snapshots();
  }

  // Get Appointment Document Changes
  Stream<DocumentSnapshot> getAppointmentStream(String appointmentId) {
    return appointmentsCollection.doc(appointmentId).snapshots();
  }

  // UPDATE APPOINTMENT
  Future<void> updateAppointment(String id, Map<String, dynamic> data) {
    return appointmentsCollection.doc(id).update(data);
  }

  // UPDATE APPOINTMENT STATUS
  Future<void> updateAppointmentStatus(String appointmentID, String newStatus) {
    return appointmentsCollection
        .doc(appointmentID)
        .update({'status': newStatus});
  }

  // DELETE
  Future<void> deleteAppointment(String appointmentID) {
    return appointmentsCollection.doc(appointmentID).delete();
  }


}
