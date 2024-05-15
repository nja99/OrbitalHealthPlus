import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // Retrieve Collection of Documents

    final CollectionReference documents =
      FirebaseFirestore.instance.collection("documents");

  // CREATE
    Future<void> addDocument(String document) {
      return documents.add({
        'document': document,
        'time_stamp': Timestamp.now()
      });
    }


  // READ

  // UPDATE

  // DELETE


}