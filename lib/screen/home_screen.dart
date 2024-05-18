import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Text Controller
  final TextEditingController textController = TextEditingController();

  // Open Dialog Box to Add New Document
  void openDocumentBox({String? documentID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // User Input
        content: TextField(controller: textController),
        // Save Button
        actions: [
          ElevatedButton(
            onPressed: () {
              // Get FirestoreService instance from Provider
              final firestoreService =
                  Provider.of<FirestoreService>(context, listen: false);

              // Add Document
              if (documentID == null) {
                firestoreService.addTask(textController.text);
              }
              // Edit Note
              else {
                firestoreService.updateTask(documentID, textController.text);
              }
              // Clear Text Controller
              textController.clear();
              // Close Dialog Box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get FirestoreService instance from Provider
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openDocumentBox,
        child: const Icon(Icons.add),
      ), //bottom right of page

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.readTaskStream(),
        builder: (context, snapshot) {
          // Retrieve Documents, If there is data
          if (snapshot.hasData) {
            List<DocumentSnapshot> documentList = snapshot.data!.docs;

            // Display List
            return ListView.builder(
              itemCount: documentList.length,
              itemBuilder: (context, index) {
                // Retrieve individual documents
                DocumentSnapshot document = documentList[index];
                String documentID = document.id;

                // Get Note from Each Document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String documentData = data['document'];

                // Display document in list tiles
                return Card(
                  child: ListTile(
                    title: Text(documentData),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          onPressed: () =>
                              openDocumentBox(documentID: documentID),
                          icon: const Icon(Icons.edit),
                        ),
                        // Delete Button
                        IconButton(
                          onPressed: () =>
                              firestoreService.deleteTask(documentID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // If there are no Documents
          else {
            return const Center(child: Text("No tasks available"));
          }
        },
      ),
    );
  }
}
