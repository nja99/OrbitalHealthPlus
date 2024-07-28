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
    required List<Map<String,String>> doseTimes,
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
    return medicationsCollection
      .orderBy('firstDose')
      .orderBy('name')
      .snapshots();
  }

  // Get Appointment Document Changes
  Stream<DocumentSnapshot> getMedicationStream(String medicationID) {
    return medicationsCollection.doc(medicationID).snapshots();
  }

  Future<DocumentSnapshot> getMedication(String medicationId) async {
    return medicationsCollection.doc(medicationId).get();
  }

  // UPDATE APPOINTMENT
  Future<void> updateMedication(String id, Map<String, dynamic> data) {
    return medicationsCollection.doc(id).update(data);
  }

  // UPDATE DOSAGE STATUS
  Future<void> updateDoseStatus(String medicationID, String doseTime, String status) async {

    try {
      // Retrieve Document
      DocumentSnapshot doc = await medicationsCollection.doc(medicationID).get();

      if(!doc.exists) {
        throw Exception("Medication Not Found");
      }
    
      Map<String, dynamic> medicationData = doc.data() as Map<String, dynamic>;
      List<dynamic> doseTimes = medicationData['doseTimes'] as List<dynamic>;

      // Update Status of Dose at Time
      bool flag = false;
      for (var dose in doseTimes) {
        if(dose['time'] == doseTime) {
          dose['status'] = status;
          flag = true;
          break;
        }
      }

      if (!flag) {
        throw Exception("Dose Not Found");
      }

      if (status == 'taken' || status == 'missed') {
        medicationData[status] = (medicationData[status] ?? 0) + 1;
      } 

      // Update Document
      await medicationsCollection.doc(medicationID).update({
        'doseTimes': doseTimes,
        'taken': medicationData['taken'],
        'missed': medicationData['missed']
      });
    } catch (error) {
      print("Error Updating Dose Status $error");
    }
  }

  // DELETE
  Future<void> deleteMedication(String medicationID) {
    return medicationsCollection.doc(medicationID).delete();
  }

}

