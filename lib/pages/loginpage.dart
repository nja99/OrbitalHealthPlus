import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/user_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Login Function
  void loginUser() {}

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
                const Icon(Icons.circle, size: 150),

                // Username
                const SizedBox(height: 100),
                UserTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                // Password
                const SizedBox(height: 15),
                UserTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                // Forgot Password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey)
                      ),
                    ],
                  ),
                ),
                
                // Login Button
                const SizedBox(height: 25),
                UserButton(
                  onTap: loginUser,
                ),

                // Register Now
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account?"),
                    SizedBox(width: 4),
                    Text(
                      'Register Now',
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
