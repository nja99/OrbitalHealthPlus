/*

import 'package:flutter/material.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/auth/register_page.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';

class LoginOrRegisterPage extends StatefulWidget {

  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
 // initially show login page
  late bool showLoginPage;

  @override
  void initState() {
    super.initState();
    final authService = getIt<AuthService>();
    showLoginPage = authService.returnShowLoginPage();
  }

 // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(

        );
    } else {
      return RegisterPage(

      );
    }
  }
}

*/

