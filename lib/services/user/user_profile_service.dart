import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

    tz.initializeTimeZones();
    final String localTimeZone = tz.local.name;

    DocumentReference userDoc = _getUserDocument(user);
    await userDoc.set({
      'email': user.email,
      'createdAt': Timestamp.now(),
      'profileCreated': false,
      'timezone': localTimeZone
    }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

    CollectionReference appointmentsCollection = userDoc.collection('appointments');
    CollectionReference medicationsCollection = userDoc.collection('medications');
  
    await appointmentsCollection.add(<String,dynamic>{});
    await medicationsCollection.add(<String, dynamic>{});
  }

  Future<void> storeUserProfile (User user, Map<String, dynamic> userData) async {
    if (userData.containsKey('firstName')) {
      await user.updateDisplayName(userData['firstName']);
    }
    
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














  Future<void> addDependent(User currentUser, String dependentEmail) async {
    await _firestore.collection('users').doc(currentUser.uid).update({
      'dependents': FieldValue.arrayUnion([dependentEmail])
    });
  }

  Future<void> addCaregiver(String dependentEmail, String caregiverEmail) async {
    var querySnapshot = await _firestore.collection('users')
        .where('email', isEqualTo: dependentEmail)
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      await _firestore.collection('users').doc(querySnapshot.docs.first.id).update({
        'caregivers': FieldValue.arrayUnion([caregiverEmail])
      });
    }
  }

  Future<List<Map<String, dynamic>>> getDependents(User currentUser) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    
    List<String> dependentEmails = [];
    if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      dependentEmails = List<String>.from(userData['dependents'] ?? []);
    }

    List<Map<String, dynamic>> dependents = [];

    for (String email in dependentEmails) {
      QuerySnapshot dependentQuery = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (dependentQuery.docs.isNotEmpty) {
        dependents.add(dependentQuery.docs.first.data() as Map<String, dynamic>);
      }
    }

    return dependents;
  }

    Future<void> switchAccount(String userId) async {
      try {
      // Get the user document for the new account
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    
      if (!userDoc.exists) {
        throw Exception('User account not found');
      }    
    // Here you would typically sign out the current user and sign in as the new user
    // However, Firebase Auth doesn't support this directly, so you might need to use custom tokens
    // or implement a different strategy for account switching
    // For now, we'll just update the current user's active account
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'activeAccount': userId
      });
    
    // You might want to trigger a state update in your app to reflect the account switch
    } catch (e) {
      print('Error switching account: $e');
      throw e;
    }
  }
  Future<void> removeCaregiver(User currentUser, String caregiverUid) async {
  try {
    DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
    if (caregiverDoc.exists) {
      String caregiverEmail = caregiverDoc['email'];
      await _firestore.collection('users').doc(currentUser.uid).update({
        'caregivers': FieldValue.arrayRemove([caregiverEmail])
      });
    }
  } catch (e) {
    print('Error removing caregiver: $e');
    throw e;
  }
}
Future<List<Map<String, dynamic>>> getCaregivers(User currentUser) async {
  DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
  
  List<String> caregiverEmails = [];
  if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    caregiverEmails = List<String>.from(userData['caregivers'] ?? []);
  }

  List<Map<String, dynamic>> caregivers = [];

  for (String email in caregiverEmails) {
    QuerySnapshot caregiverQuery = await _firestore.collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    if (caregiverQuery.docs.isNotEmpty) {
      caregivers.add(caregiverQuery.docs.first.data() as Map<String, dynamic>);
    }
  }

  return caregivers;
}

}

