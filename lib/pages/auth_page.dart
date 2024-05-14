import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/pages/login_page.dart';
import 'package:healthsphere/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is LOGGED IN
          if (snapshot.hasData) {
            return HomePage();
          }

          // User is NOT LOGGED IN
          else {
            return LoginPage();
          }
        }

      )
    );
  }
}