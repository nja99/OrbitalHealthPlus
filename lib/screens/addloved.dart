import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';

class AddLovedOnePage extends StatefulWidget {

  const AddLovedOnePage({super.key});

  @override
  _AddLovedOnePageState createState() => _AddLovedOnePageState();
}

class _AddLovedOnePageState extends State<AddLovedOnePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserProfileService _userProfileService = UserProfileService();
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
    if (_emailController.text == _currentUser.email) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot add yourself as a caregiver.')),
      );
      return;
    }

    // Check if the email already exists in the user's loved ones
    bool alreadyAdded = await _userProfileService.isAlreadyAddedAsLovedOne(_currentUser!, _emailController.text);
    if (alreadyAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This person is already added as a loved one.')),
      );
      return;
    }

    bool emailExists = await _doesEmailExist(_emailController.text);
    if (!emailExists) {
      throw Exception('No account found with this email');
    }

    // Add the dependent and update the caregiver
    await _userProfileService.addDependent(_currentUser, _emailController.text);
    await _userProfileService.addCaregiver(_emailController.text, _currentUser.email!);

    // Pass back the email and password
    Navigator.pop(context, {
      'email': _emailController.text,
      'password': _passwordController.text,
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Loved One')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email of Loved One'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLovedOne,
              child: Text('Add Loved One'),
            ),
          ],
        ),
      ),
    );
  }
}
