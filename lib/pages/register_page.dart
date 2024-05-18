import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/custom_alert_dialog.dart';
import 'package:healthsphere/components/user_textfield.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/utils/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

    // Loading state
  bool _isLoading = false;


  // Login Function
  void userSignUp() async {

    // Get Auth Service
    final authService = AuthService();


    // Show loading indicator
    setState(() {
      _isLoading = true;
    });


    // Check if Password Matches -> Create User
    if (passwordController.text == confirmPasswordController.text) {
      // Attempt to create user
      try {
        await authService.signUpWithEmailPassword(emailController.text, passwordController.text);
        // Sign Out after successful sign-up
        await authService.signOut();
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
      // Catch Sign Up Errors
      catch (e) {
        // Remove Loading Circle
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          showCustomDialog(context, e.toString(), "Please try again.");
        }
      }
    } 
    // If Password does not match -> Prompt Message
    else {
      if (mounted) {
        setState(() {
          _isLoading = false;
      });
      showCustomDialog(context, "Mismatch Error", "Passwords don't match!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingOverlay(
      _isLoading,
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                // Logo
                Image.asset("lib/assets/images/Logo.png", height: 160),
                const SizedBox(height: 50),
      
                // Create account text
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
      
                // Email
                const SizedBox(height: 25),
                UserTextField(
                  controller: emailController,
                  labelText: "E-mail",
                  obscureText: false,
                ),
      
                // Password
                const SizedBox(height: 15),
                UserTextField(
                  controller: passwordController,
                  labelText: "Password",
                  obscureText: true,
                ),
      
                // Confirm Password
                const SizedBox(height: 15),
                UserTextField(
                  controller: confirmPasswordController,
                  labelText: "Confirm Password",
                  obscureText: true,
                ),
                
                // Sign Up Button
                const SizedBox(height: 25),
                UserButton(buttonText: "Sign Up", onPressed: userSignUp),
                // Already have an account
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Now",
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
