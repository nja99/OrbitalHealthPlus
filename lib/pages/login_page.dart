import 'package:flutter/material.dart';
import 'package:healthsphere/components/loading_overlay.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/custom_alert_dialog.dart';
import 'package:healthsphere/components/user_textfield.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  bool isLoading = false;

  // Login Function
  void userSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    // Attempt Sign In
    try {
      // Sign User In
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
      // Remove Loading Circle
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showCustomDialog(context, e.toString(), "Please try again.");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildLoadingOverlay(
      isLoading,
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Image.asset("lib/assets/images/Logo.png", height: 160),
                  const SizedBox(height: 50),
                  // Welcome back!
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Email
                  const SizedBox(height: 50),
                  UserTextField(
                    controller: emailController,
                    labelText: "Email Address",
                    obscureText: false,
                  ),
                  // Password
                  const SizedBox(height: 15),
                  UserTextField(
                    controller: passwordController,
                    labelText: "Password",
                    obscureText: true,
                  ),
                  // Forgot Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  // Login Button
                  const SizedBox(height: 25),
                  UserButton(
                    buttonText: "Log in",
                    onPressed: userSignIn,
                  ),
                  // Register Now
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an Account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
