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

    Future<void> initializeApp() async {
    await migrateUserDocuments();
    // You can add other initialization tasks here if needed
  }

  Future<void> migrateUserDocuments() async {
  QuerySnapshot userDocs = await _firestore.collection('users').get();
  
  for (QueryDocumentSnapshot doc in userDocs.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (!data.containsKey('caregivers')) {
      await doc.reference.set({'caregivers': []}, SetOptions(merge: true));
    }
  }
}




  Future<void> createUserProfile(User user) async {
  DocumentReference userDoc = _getUserDocument(user);
  await userDoc.set({
    'email': user.email,
    'createdAt': Timestamp.now(),
    'profileCreated': false,
    'caregivers': [],  // Initialize caregivers as an empty list
  }, SetOptions(merge: true));
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














  Future<void> addDependent(User currentUser, String dependentEmail) async {
  final dependentDoc = await _firestore.collection('users').where('email', isEqualTo: dependentEmail).get();
  if (dependentDoc.docs.isNotEmpty) {
    final dependentData = dependentDoc.docs.first.data();
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('dependents')
        .doc(dependentEmail)
        .set({
      'email': dependentEmail,  // Make sure this line is included
      'firstName': dependentData['firstName'] ?? '',
      'lastName': dependentData['lastName'] ?? '',
      'height': dependentData['height'] ?? 'N/A',
      'weight': dependentData['weight'] ?? 'N/A',
    });
  }
}


  Future<void> addCaregiver(String dependentEmail, String caregiverEmail) async {
  var querySnapshot = await _firestore.collection('users')
      .where('email', isEqualTo: dependentEmail)
      .get();
  
  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference userDoc = _firestore.collection('users').doc(querySnapshot.docs.first.id);
    
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);
      
      if (!snapshot.exists || !(snapshot.data() as Map<String, dynamic>?)?['caregivers'] is List) {
        transaction.set(userDoc, {'caregivers': [caregiverEmail]}, SetOptions(merge: true));
      } else {
        List<dynamic> currentCaregivers = (snapshot.data() as Map<String, dynamic>)['caregivers'];
        if (!currentCaregivers.contains(caregiverEmail)) {
          currentCaregivers.add(caregiverEmail);
          transaction.update(userDoc, {'caregivers': currentCaregivers});
        }
      }
    });
  }
}


Future<List<Map<String, dynamic>>> getDependents(User user) async {
  QuerySnapshot dependentsSnapshot = await _firestore
      .collection('users')
      .doc(user.uid)
      .collection('dependents')
      .get();

  return dependentsSnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}


  Future<User?> switchAccount(String email) async {
  try {
    // Fetch the user document to get the password
    QuerySnapshot userSnapshot = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();
    
    if (userSnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    // Get the user data
    Map<String, dynamic> userData = userSnapshot.docs.first.data() as Map<String, dynamic>; 
    // Check if the password is stored (it shouldn't be in a real app for security reasons)
    String? password = userData['password'];
    if (password == null) {
      throw Exception('Password not found for user');
    }
    // Sign out the current user
    await FirebaseAuth.instance.signOut();
    // Sign in with the new email and password
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Error switching account: $e');
    return null;
  }
}




Future<void> removeDependent(User currentUser, String dependentEmail) async {
  await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('dependents')
      .doc(dependentEmail)
      .delete();
}


Future<bool> isAlreadyAddedAsLovedOne(User currentUser, String email) async {
  // Check dependents
  QuerySnapshot dependentSnapshot = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('dependents')
      .where('email', isEqualTo: email)
      .get();
  if (dependentSnapshot.docs.isNotEmpty) {
    return true;
  }
  
  // Check caregivers
  DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
  
  if (userDoc.exists && userDoc.data() != null) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    if (userData['caregivers'] is List) {
      List<dynamic> caregivers = userData['caregivers'];
      return caregivers.contains(email);
    }
  }
  
  return false;
}

  

Future<void> removeCaregiver(User currentUser, String caregiverEmail) async {
  try {
    // Remove caregiver from current user's caregivers list
    await _firestore.collection('users').doc(currentUser.uid).update({
      'caregivers': FieldValue.arrayRemove([caregiverEmail])
    });

    // Remove current user from caregiver's dependents
    QuerySnapshot caregiverDoc = await _firestore.collection('users')
        .where('email', isEqualTo: caregiverEmail)
        .limit(1)
        .get();
    
    if (caregiverDoc.docs.isNotEmpty) {
      String caregiverId = caregiverDoc.docs.first.id;
      await _firestore.collection('users')
          .doc(caregiverId)
          .collection('dependents')
          .doc(currentUser.email)
          .delete();
    }

    print('Caregiver removed successfully');
  } catch (e) {
    print('Error removing caregiver: $e');
    throw e;
  }
}



Future<List<Map<String, dynamic>>> getCaregivers(User currentUser) async {
  DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
  
  List<String> caregiverEmails = [];
  if (userDoc.exists && userDoc.data() != null) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    if (userData['caregivers'] is List) {
      caregiverEmails = List<String>.from(userData['caregivers']);
    }
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

