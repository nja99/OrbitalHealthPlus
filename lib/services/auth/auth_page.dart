import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/home_page.dart';
import 'package:healthsphere/services/service_locator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    
    final FirebaseAuth firebaseAuth = getIt<FirebaseAuth>();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          // User is LOGGED IN
          if (snapshot.hasData) {
            return const HomePage();
          }        
          // User is NOT LOGGED IN
          else {
            return const LoginPage();
          }
        }

      )
    );
  }
}