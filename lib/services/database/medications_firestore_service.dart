import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';

class MedicationFirestoreService {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  // Retrieve Collection of medications
  CollectionReference get medicationsCollection {
    String uid = _firebaseAuth.currentUser?.uid ?? '';
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('medications');
  }

  // CREATE
  Future<void> addMedication(String name, String purpose, String? route, String amount, String unit, String? frequency, String? instruction) {
    return medicationsCollection.add({
      'name': name,
      'purpose': purpose,
      'route': route,
      'amount': amount,
      'unit': unit,
      'frequency': frequency,
      'instruction': instruction,
    });
  }

  // READ
  Stream<QuerySnapshot> readMedicationStream() {
    return medicationsCollection.orderBy('date_time').snapshots();
  }

  // Get Appointment Document Changes
  Stream<DocumentSnapshot> getMedicationStream(String medicationID) {
    return medicationsCollection.doc(medicationID).snapshots();
  }

  // UPDATE APPOINTMENT
  Future<void> updateMedication(String medicationID, String newTitle, String newDescription, String newLocation, Timestamp newFormattedDateTime, String status) {
    return medicationsCollection.doc(medicationID).update({
      'title': newTitle,
      'description': newDescription,
      'location': newLocation,
      'date_time': newFormattedDateTime,
      'status': status
    });
  }

  // UPDATE APPOINTMENT STATUS
  Future<void> updateMedicationStatus(String medicationID, String newStatus) {
    return medicationsCollection
        .doc(medicationID)
        .update({'status': newStatus});
  }

  // DELETE
  Future<void> deleteMedication(String medicationID) {
    return medicationsCollection.doc(medicationID).delete();
  }
}

