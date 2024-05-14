import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/user_textfield.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

    // User Not Found Function
  void userNotFound() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("User Not Found"),
        );
      }
    );
  }

  // Incorrect Password Function
  void incorrectPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Password"),
        );
      }
    );
  }

  // Login Function
  void userSignIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );
      
      // Remove Loading Circle
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      // Remove Loading Circle
      Navigator.pop(context);

      // User Does Not Exists
      if (e.code == "user-not-found") {
        userNotFound();
      } 
      
      // Incorrect Password
      else if (e.code == "wrong-password") {
        incorrectPassword();
      }
    }
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
                  onTap: userSignIn
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
                      )),
                  ],)


              ],
            ),
          ),
        ));
  }
}
