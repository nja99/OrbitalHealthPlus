import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/home_drawer.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
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
    final authService = AuthService();
    authService.signOut();
  }

  // Open Dialog Box to Add New Document
  void openDocumentBox ({String? documentID}) {
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
              if (documentID == null) {
                firestoreService.addDocument(textController.text);
              }
              // Edit Note
              else {
                firestoreService.updateDocument(documentID, textController.text);
              }
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
        title:const Text("HEALTHSPHERE"),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: userSignOut, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),

      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: openDocumentBox,
        child: const Icon(Icons.add),
      ),//bottom right of page

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.readDocumentStream(),
        builder: (context, snapshot) {
          // Retrieve Documents, If there is data
          if(snapshot.hasData) {
            List documentList = snapshot.data!.docs;

            // Display List
            return ListView.builder(
              itemCount: documentList.length,
              itemBuilder: (context,index) {

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
                          onPressed: () => openDocumentBox(documentID: documentID),
                          icon: const Icon(Icons.edit),
                        ),
                        //Delete Button
                        IconButton(
                          onPressed: () => firestoreService.deleteDocument(documentID),
                          icon: const Icon(Icons.delete),
                        )
                      ]
                    )
                  ),
                );
              }
            );
          }
          // If there are no Documents
          else {
            return const Text(" ");
          }
        },
      )
    );
  }
}