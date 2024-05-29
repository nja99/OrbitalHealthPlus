import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';

class FirestoreService {

  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

// Retrieve Collection of Documents
  CollectionReference get tasksCollection {
    String uid = _firebaseAuth.currentUser?.uid ?? '';
    return _firebaseFirestore.collection('users').doc(uid).collection('tasks');
  }

// CREATE
  Future<void> addTask(String document) {
    return tasksCollection
      .add({'document': document, 'time_stamp': Timestamp.now()});
  }

  // READ
  Stream<QuerySnapshot> readTaskStream() {
    return tasksCollection.orderBy('time_stamp', descending: true).snapshots();
  }
  // UPDATE
  Future<void> updateTask(String documentID, String newDocument) {
    return tasksCollection
      .doc(documentID)
      .update({'document': newDocument, 'time_stamp': Timestamp.now()});
  }

  // DELETE
  Future<void> deleteTask(String documentID) {
    return tasksCollection.doc(documentID).delete();
  }
}