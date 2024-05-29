import 'package:flutter/material.dart';
import 'package:healthsphere/components/user_button.dart';
import 'package:healthsphere/components/user_textfield.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/user/user_service_locator.dart';
import 'package:healthsphere/utils/loading_overlay.dart';
import 'package:healthsphere/components/custom_alert_dialog.dart';


class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}


class _ForgetPasswordPageState extends State<ForgetPasswordPage> {

  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _authService = getIt<AuthService>();

  @override 
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async { 
    try {
      await _authService.resetPassword(_emailController.text);
      showCustomDialog(context, "Password Reset link sent!", "Please check your email!");
      // Remove Loading Circle
    }
    catch (e) {
      showCustomDialog(context, e.toString(), "Please try again.");
      }
  } 

  @override
  Widget build(BuildContext context) {
    return loadingOverlay(
        _isLoading,
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 15),
                child: Text(
                  'Enter your email and we will send you a password reset link',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              UserTextField(
                controller: _emailController,
                labelText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
                  UserButton(
                    buttonText: "Reset Password",
                    onPressed: passwordReset,
                  ),
            ],
          )),
    );
  }
}
