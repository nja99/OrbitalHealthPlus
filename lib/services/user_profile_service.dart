import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseFirestore _firestore;

  UserProfileService(this._firestore);

  DocumentReference _getUserDocument(User user) {
    return _firestore.collection('users').doc(user.uid);
  }

  Future<void> createUserProfile(User user) async {
    DocumentReference userDoc = _getUserDocument(user);
    await userDoc.set({
      'email': user.email,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

    CollectionReference tasksCollection = userDoc.collection('tasks');
    await tasksCollection.add(<String, dynamic>{});
  }
}