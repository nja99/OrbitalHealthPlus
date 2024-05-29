import 'package:flutter/material.dart';
import 'package:healthsphere/components/square_tile.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/custom_alert_dialog.dart';
import 'package:healthsphere/components/user_textfield.dart';
import 'package:healthsphere/pages/auth/forget_pw_page.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/utils/loading_overlay.dart';

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
  bool _isLoading = false;
  final authService = getIt<AuthService>();


  // Login Function
  void userSignIn() async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });
    // Attempt Sign In
    try {
      await authService.signInWithEmailPassword(emailController.text, passwordController.text);
      // Remove Loading Circle
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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



  @override
  Widget build(BuildContext context) {
    return loadingOverlay(
      _isLoading,
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: ListView(
              children: [
                
                // Logo
                const SizedBox(height: 60),
                Image.asset("lib/assets/images/logo_light.png", height: 120),
                
                // Welcome back!
                const SizedBox(height: 50),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Email
                const SizedBox(height: 30),
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

                const SizedBox(height: 3),
                // Forgot Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgetPasswordPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Login Button
                const SizedBox(height: 10),
                UserButton(
                  buttonText: "Log in",
                  onPressed: userSignIn,
                ),

                // Register Now
                const SizedBox(height: 25),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness:1,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness:1,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //google and facebook sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                      imagePath: 'lib/assets/images/google_logo.png',
                      height: 15.0,
                      onTap: () => authService.signInWithGoogle(),
                      ),
                    const SizedBox(width: 25),
                    //facebook button
                    SquareTile(
                      imagePath: 'lib/assets/images/facebook_logo.png',
                      height: 15.0,
                      onTap: () {},
                      ),
                  ],
                ),

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