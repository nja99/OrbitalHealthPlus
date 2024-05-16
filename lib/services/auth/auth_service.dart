import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // Get instance of Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get Current User
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    
    // Attempt to Sign In
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    
    // Catch Errors if Sign In Fails
    on FirebaseAuthException catch (e) {

      throw Exception(e.code);

    } 
  }

  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, password) async {
    // Attempt to Sign In
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }

    // Catch Errors if Sign In Fails
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // Sign Out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

}