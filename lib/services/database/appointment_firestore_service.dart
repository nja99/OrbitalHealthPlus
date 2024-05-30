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
  Future<void> addAppointment(String title, String description, String location, String formattedDateTime) {
    return appointmentsCollection
      .add({
        'title': title,
        'description': description,
        'location': location,
        'date_time': formattedDateTime
      });
  }

  // READ
  Stream<QuerySnapshot> readAppointmentStream() {
    return appointmentsCollection
      .orderBy('date_time')
      .snapshots();
  }

  // UPDATE
  Future<void> updateAppointment(String appointmentID, String newAppointment) {
    return appointmentsCollection
      .doc(appointmentID)
      .update({'appointment': newAppointment, 'time_stamp': Timestamp.now()});
  }

  // DELETE
  Future<void> deleteAppointment(String appointmentID) {
    return appointmentsCollection.doc(appointmentID).delete();
  }
}
