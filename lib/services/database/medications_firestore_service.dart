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

  // Medication Data Structure
  Map<String, dynamic> constructMedicationData({
    required String name,
    required String purpose,
    required String route,
    required String amount,
    required String unit,
    required String frequency,
    required String instruction,
    required String firstDose,
    required List<String> doseTimes,
    int taken = 0,
    int missed = 0,
  }) {
    return {
      'name': name,
      'purpose': purpose,
      'route': route,
      'amount': amount,
      'unit': unit,
      'frequency': frequency,
      'instruction': instruction,
      'firstDose': firstDose,
      'doseTimes': doseTimes,
      'taken': taken,
      'missed': missed,
    };
  }

  // CREATE
  Future<void> addMedication(Map<String, dynamic> data) {
    return medicationsCollection.add(data);
  }

  // READ
  Stream<QuerySnapshot> readMedicationStream() {
    return medicationsCollection.orderBy('firstDose').snapshots();
  }

  // Get Appointment Document Changes
  Stream<DocumentSnapshot> getMedicationStream(String medicationID) {
    return medicationsCollection.doc(medicationID).snapshots();
  }

  // UPDATE APPOINTMENT
Future<void> updateMedication(String id, Map<String, dynamic> data) {
    return medicationsCollection.doc(id).update(data);
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

