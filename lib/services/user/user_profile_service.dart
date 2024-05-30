import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';

class UserProfileService {
  
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

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
    CollectionReference appointmentsCollection = userDoc.collection('appointments');
    CollectionReference medicationsCollection = userDoc.collection('medications');
  
    await tasksCollection.add(<String, dynamic>{});
    await appointmentsCollection.add(<String,dynamic>{});
    await medicationsCollection.add(<String, dynamic>{});
  }
}
