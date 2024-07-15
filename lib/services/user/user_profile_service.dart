import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';


class UserProfileService {
  
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();

  DocumentReference _getUserDocument(User user) {
    return _firestore.collection('users').doc(user.uid);
  }

  // User Profile Data Structure
  Map<String, dynamic> constructUserData({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String sex,
    required String bloodType
  }) {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'height': height,
      'weight': weight,
      'sex': sex,
      'bloodType': bloodType,
      'profileCreated': true,
    };
  }

  Future<void> createUserProfile(User user) async {
    DocumentReference userDoc = _getUserDocument(user);
    await userDoc.set({
      'email': user.email,
      'createdAt': Timestamp.now(),
      'profileCreated': false,
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

    CollectionReference appointmentsCollection = userDoc.collection('appointments');
    CollectionReference medicationsCollection = userDoc.collection('medications');
  
    await appointmentsCollection.add(<String,dynamic>{});
    await medicationsCollection.add(<String, dynamic>{});
  }

  Future<void> storeUserProfile (User user, Map<String, dynamic> userData) async {
    DocumentReference userDoc = _getUserDocument(user);
    await userDoc.set(userData, SetOptions(merge: true));
  }

  Future<bool> isProfileCreated(User user) async {
    DocumentSnapshot userProfile = await _getUserDocument(user).get();
    if (userProfile.exists) {
      return userProfile['profileCreated'] ?? false;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUserProfile(User user) async {
    try {
      DocumentSnapshot userDoc = await _getUserDocument(user).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
