import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:healthsphere/components/user_button.dart";

class OnBoardingPage extends StatelessWidget {

  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Placeholder
              SizedBox(
                height:500,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("lib/assets/images/onboarding.png")
                    )
                  ),
                  child: Container(
                    width:50,
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x00FFFFFF), Colors.white],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      )
                    ),
                    alignment: const AlignmentDirectional(0, 0.5),
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                      child: Text(
                        "Welcome to HealthSPHERE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          color: Color(0xFF101213),
                          fontWeight: FontWeight.bold
                        ),)
                    )
                  )
                ),
              ),

              // Sign Up with E-mail
              UserButton(
                buttonText: "Sign Up with Email", 
                onPressed: () {},
                iconData: Icons.email
              ),

              // Or Use Social Media
              Text(
                "Or use social media",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),

              // Sign up with Google
              const SizedBox(height: 5),
              UserButton(
                buttonText: "Sign Up with Google", 
                onPressed: () {},
                iconData: FontAwesomeIcons.google
              ),

              // Sign up with Facebook
              UserButton(
                buttonText: "Sign Up with Facebook", 
                onPressed: () {},
                iconData: FontAwesomeIcons.facebook,
              ),


              // Already Have an Account? Log In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Have an Account?"),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {},
                    child: const Text (
                      "Log In!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}