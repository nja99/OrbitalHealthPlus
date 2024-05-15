import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/firestore.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  // Fire Store //
  final FirestoreService firestoreService = FirestoreService();

  // Text Controller //
  final TextEditingController textController = TextEditingController();

  // Functions //
  // Sign Out
  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  // Open Dialog Box to Add New Document
  void openDocumentBox () {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(

        // User Input
        content: TextField(
          controller: textController
        ),
        // Save Button
        actions: [
          ElevatedButton(
            onPressed: () {
              // Add Document
              firestoreService.addDocument(textController.text);

              // Clear Text Controller
              textController.clear();

              // Close Dialog Box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      )
    );
  }

  @override
  Widget build (BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: userSignOut, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openDocumentBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}