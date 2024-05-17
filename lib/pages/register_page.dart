import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/custom_alert_dialog.dart';
import 'package:healthsphere/components/user_textfield.dart';
import 'package:healthsphere/services/auth/auth_service.dart';

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

  // Login Function
  void userSignUp() async {

    // Get Auth Service
    final authService = AuthService();

    // Loading Circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // Check if Password Matches -> Create User
    if (passwordController.text == confirmPasswordController.text) {
      // Attempt to create user
      try {
        await authService.signUpWithEmailPassword(emailController.text, passwordController.text);
        authService.signOut();
        Navigator.pop(context);
      }
      // Catch Sign Up Errors
      catch (e) {
        Navigator.pop(context);
        showCustomDialog(context, e.toString(), "Please try again.");
      }
    } 
    // If Password does not match -> Prompt Message
    else {
        showCustomDialog(context, "Mismatch Error", "Passwords don't match!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:SafeArea(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 50),
                
              // Logo
              Image.asset(
                "lib/assets/images/Logo.png",
                height: 160),

                const SizedBox(height: 50),

                //let's create an account for you
                Text(
                  'Let\'s create and account for you!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize:14,
                  ),
                  textAlign: TextAlign.center,
                ),

              // Email
              const SizedBox(height: 25),
              UserTextField(
                controller: emailController,
                hintText: "E-mail",
                obscureText: false,
              ),

              // Password
              const SizedBox(height: 15),
              UserTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              // Confirm Password
              const SizedBox(height: 15),
              UserTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),

              
              // Login Button
              const SizedBox(height: 25),
              UserButton(
                buttonText: "Sign Up",
                onPressed: userSignUp
              ),

              // Register Now
              const SizedBox(height: 25),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(" Already have an Account?"),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                        "Login Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
