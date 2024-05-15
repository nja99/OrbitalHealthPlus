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
  Stream<QuerySnapshot> readDocumentStream() {
    final documentStream = 
      documents.orderBy('time_stamp', descending: true).snapshots();
    
    return documentStream;
  }

  // UPDATE
  Future<void> updateDocument(String documentID, String newDocument) {
    return documents.doc(documentID).update({
      'document': newDocument,
      'time_stamp': Timestamp.now()
    });
  }

  // DELETE
  Future<void> deleteDocument(String documentID) {
    return documents.doc(documentID).delete();
  }


}