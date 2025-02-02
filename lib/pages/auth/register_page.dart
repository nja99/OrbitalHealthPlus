import 'package:flutter/material.dart';
import 'package:healthsphere/components/buttons/user_button.dart';
import 'package:healthsphere/components/dialogs/custom_alert_dialog.dart';
import 'package:healthsphere/components/forms/user_textfield.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/user_onboarding/profile_collection_page.dart';
import 'package:healthsphere/services/auth/auth_provider.dart';
import 'package:healthsphere/utils/loading_overlay.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  // Login Function
  void userSignUp() async {

    // Get Auth Provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Check if Password Matches -> Create User
    if (passwordController.text == confirmPasswordController.text) {
      // Attempt to create user
      try {
        await authProvider.register(emailController.text, passwordController.text);
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to Login Page
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileCollectionPage()));
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
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  const SizedBox(height: 60),
                  Image.asset("lib/assets/images/logo_light.png", height: 160),
                    
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
                        onTap: () { Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const LoginPage())); },
                        child: const Text(
                          "Login Now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
