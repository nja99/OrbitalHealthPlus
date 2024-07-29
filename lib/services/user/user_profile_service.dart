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
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No authenticated user');
      return;
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    
    if (!userDoc.exists || !(userDoc.data() as Map<String, dynamic>?)?['caregivers'] is List) {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'caregivers': []
      }, SetOptions(merge: true));
    }
    
    print('Migration completed successfully');
  } catch (e) {
    print('Error during migration: $e');
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










Stream<List<Map<String, dynamic>>> getDependentsStream(User user) {
    return _firestore
      .collection('users')
      .doc(user.uid)
      .collection('dependents')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  Stream<List<Map<String, dynamic>>> getCaregiversStream(User user) {
    return _firestore
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        List<String> caregiverEmails = List<String>.from(snapshot.data()?['caregivers'] ?? []);
        return caregiverEmails;
      })
      .asyncMap((emails) async {
        List<Map<String, dynamic>> caregivers = [];
        for (String email in emails) {
          QuerySnapshot caregiverQuery = await _firestore.collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();
          if (caregiverQuery.docs.isNotEmpty) {
            caregivers.add(caregiverQuery.docs.first.data() as Map<String, dynamic>);
          }
        }
        return caregivers;
      });
  }
  






















  Future<void> addDependent(User currentUser, String dependentEmail) async {
  print('Adding dependent: $dependentEmail for user: ${currentUser.email}');
  
  // Check if already a dependent
  bool isAlreadyDependent = await isAlreadyAddedAsLovedOne(currentUser, dependentEmail);
  if (isAlreadyDependent) {
    print('$dependentEmail is already a dependent of ${currentUser.email}');
    throw Exception('This person is already added as a loved one.');
  }

  final dependentDoc = await _firestore.collection('users').where('email', isEqualTo: dependentEmail).get();
  if (dependentDoc.docs.isNotEmpty) {
    final dependentData = dependentDoc.docs.first.data();
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('dependents')
        .doc(dependentEmail)
        .set({
      'email': dependentEmail,
      'firstName': dependentData['firstName'] ?? '',
      'lastName': dependentData['lastName'] ?? '',
      'height': dependentData['height'] ?? 'N/A',
      'weight': dependentData['weight'] ?? 'N/A',
    });
    print('Dependent added successfully');
  } else {
    print('No user found with email: $dependentEmail');
    throw Exception('No user found with this email');
  }
}

Future<void> addCaregiver(String dependentEmail, String caregiverEmail) async {
  print('Adding caregiver: $caregiverEmail for dependent: $dependentEmail');
  
  var querySnapshot = await _firestore.collection('users')
      .where('email', isEqualTo: dependentEmail)
      .get();
  
  if (querySnapshot.docs.isNotEmpty) {
    DocumentReference userDoc = _firestore.collection('users').doc(querySnapshot.docs.first.id);
    
    // Check if already a caregiver
    DocumentSnapshot snapshot = await userDoc.get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> caregivers = userData['caregivers'] ?? [];
      if (caregivers.contains(caregiverEmail)) {
        print('$caregiverEmail is already a caregiver of $dependentEmail');
        throw Exception('This person is already added as a caregiver.');
      }
    }

    await _firestore.runTransaction((transaction) async {
      transaction.update(userDoc, {
        'caregivers': FieldValue.arrayUnion([caregiverEmail])
      });
    });
    print('Caregiver added successfully');
  } else {
    print('No user found with email: $dependentEmail');
    throw Exception('No user found with this email');
  }
}




Future<void> removeDependent(User currentUser, String dependentEmail) async {
  try {
    // Remove from dependents collection
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('dependents')
        .doc(dependentEmail)
        .delete();

    // Remove from caregivers array
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({
          'caregivers': FieldValue.arrayRemove([dependentEmail])
        });

    // Remove current user from dependent's caregivers
    QuerySnapshot dependentDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: dependentEmail)
        .get();
    
    if (dependentDoc.docs.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(dependentDoc.docs.first.id)
          .update({
            'caregivers': FieldValue.arrayRemove([currentUser.email])
          });
    }
  } catch (e) {
    print('Error removing dependent: $e');
    throw e;
  }
}



Future<void> removeCaregiver(User currentUser, String caregiverEmail) async {
    try {
      // Remove from current user's caregivers list
      await _firestore.collection('users').doc(currentUser.uid).update({
        'caregivers': FieldValue.arrayRemove([caregiverEmail])
      });
      // Remove from dependents collection
      await _firestore.collection('users')
          .doc(currentUser.uid)
          .collection('dependents')
          .doc(caregiverEmail)
          .delete();
      // Remove current user from caregiver's dependents
      QuerySnapshot caregiverDoc = await _firestore.collection('users')
          .where('email', isEqualTo: caregiverEmail)
          .limit(1)
          .get();
      if (caregiverDoc.docs.isNotEmpty) {
        String caregiverId = caregiverDoc.docs.first.id;
        await _firestore.collection('users')
            .doc(caregiverId)
            .update({
              'dependents': FieldValue.arrayRemove([currentUser.email])
            });
      }
      print('Caregiver removed successfully');
    } catch (e) {
      print('Error removing caregiver: $e');
      throw e;
    }
  }














Future<bool> isAlreadyAddedAsLovedOne(User currentUser, String email) async {
  try {
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
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> caregivers = userData['caregivers'] ?? [];
      if (caregivers.contains(email)) {
        return true;
      }
    }

    return false;
  } catch (e) {
    print('Error checking if loved one is already added: $e');
    return false;
  }
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

}