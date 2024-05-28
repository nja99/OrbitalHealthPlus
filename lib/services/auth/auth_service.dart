

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {

  // Get instance of Firebase Auth
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final UserProfileService _userProfileService = UserProfileService();
  

  signInWithGoogle() async {

    await GoogleSignIn().signOut();
    //begin interactive sign in process 
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // finally, lets sign in

    return await _firebaseAuth.signInWithCredential(credential);
  }


  


  // Get Current User
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    // Attempt to Sign In
    try {
      UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    // Catch Errors if Sign In Fails
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } 
  }

  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    // Attempt to Sign In
    try {
      UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        await _userProfileService.createUserProfile(user);
      }
      
      return userCredential;
    }
    // Catch Errors if Sign In Fails
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } 
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}