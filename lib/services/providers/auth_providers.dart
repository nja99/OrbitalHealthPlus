import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthsphere/services/user_profile_service.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/firestore.dart';

class AuthProviders extends StatelessWidget {
  final Widget child;

  const AuthProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
        ProxyProvider<FirebaseFirestore, UserProfileService>(
          update: (_, firestore, __) => UserProfileService(firestore),
        ),
        ProxyProvider2<FirebaseAuth, UserProfileService, AuthService>(
          update: (_, firebaseAuth, userProfileService, __) =>
              AuthService(firebaseAuth, userProfileService),
        ),
        ProxyProvider2<FirebaseAuth, FirebaseFirestore, FirestoreService>(
          update: (_, firebaseAuth, firebaseFirestore, __) =>
              FirestoreService(firebaseAuth, firebaseFirestore),
        ),
      ],
      child: child,
    );
  }
}
