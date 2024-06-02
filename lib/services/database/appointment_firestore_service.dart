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

  // CREATE
  Future<void> addAppointment(String title, String description, String location, Timestamp formattedDateTime, String status) {
    return appointmentsCollection
      .add({
          'title': title,
          'description': description,
          'location': location,
          'date_time': formattedDateTime,
          'status': status
      });
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
  Future<void> updateAppointment(String appointmentID, String newTitle, String newDescription, String newLocation, Timestamp newFormattedDateTime, String status) {
    return appointmentsCollection
      .doc(appointmentID)
      .update({
          'title': newTitle,
          'description': newDescription,
          'location': newLocation,
          'date_time': newFormattedDateTime,
          'status': status
      });
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
