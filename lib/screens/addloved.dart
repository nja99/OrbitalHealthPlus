

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/buttons/user_button.dart';
import 'package:healthsphere/components/forms/user_textfield.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';

class AddLovedOnePage extends StatefulWidget {
  @override
  _AddLovedOnePageState createState() => _AddLovedOnePageState();
}

class _AddLovedOnePageState extends State<AddLovedOnePage> {
  final TextEditingController _emailController = TextEditingController();
  final UserProfileService _userProfileService = getIt<UserProfileService>();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<bool> _doesEmailExist(String email) async {
  final querySnapshot = await FirebaseFirestore.instance
    .collection('users')
    .where('email', isEqualTo: email)
    .get();
  return querySnapshot.docs.isNotEmpty;
}

Future<void> _addLovedOne() async {
  if (_currentUser == null) return;

  try {
    // Check if the email is the same as the current user's email
    if (_emailController.text == _currentUser!.email) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot add yourself as a caregiver.')),
      );
      return;
    }

    bool emailExists = await _doesEmailExist(_emailController.text);
    if (!emailExists) {
      throw Exception('No account found with this email');
    }

    // Add the dependent and update the caregiver
    await _userProfileService.addDependent(_currentUser!, _emailController.text);
    await _userProfileService.addCaregiver(_emailController.text, _currentUser!.email!);

    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Loved One')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            UserTextField(
              controller: _emailController,
              labelText: 'Email of Loved One',
            ),
            const SizedBox(height: 20),
            UserButton(
              buttonText: 'Add Loved One',
              onPressed: _addLovedOne,
            ),
          ],
        ),
      ),
    );
  }
}