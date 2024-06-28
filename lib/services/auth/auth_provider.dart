import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService = getIt<AuthService>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  
  User? _user;
  User? get user => _user;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmailPassword(email, password);
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await _authService.signInWithEmailPassword(email, password);
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

}