import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/user_popupalerts.dart';
import 'package:healthsphere/components/user_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // Login Function
  void userSignIn() async {
    
    // Loading Circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    
    // Attempt Sign In
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );
      
      // Remove Loading Circle
      Navigator.pop(context);
    
    } on FirebaseAuthException catch(e) {

      // Remove Loading Circle
      Navigator.pop(context);

      if (e.code == 'invalid-email') {
        showCustomDialog(context, "Invalid Email", "Please check if you entered your e-mail correctly.");
      }
      // Invalid Credentials
      else if (e.code == 'invalid-credential') {
        showCustomDialog(context, "Invalid Credentials", "Please try again.");
      }
    }
  }

  void showCustomDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopUpAlerts(title: title, description: description);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
                
              // Logo
              Image.asset(
                "lib/assets/images/Logo.png",
                height: 150),

              // Email
              const SizedBox(height: 100),
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

              // Forgot Password
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey)
                    ),
                  ],
                ),
              ),
              
              // Login Button
              const SizedBox(height: 25),
              UserButton(
                buttonText: "Log in",
                onPressed: userSignIn
              ),

              // Register Now
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account?"),
                  SizedBox(width: 4),
                  Text(
                    "Register Now",
                    style:TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )
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
