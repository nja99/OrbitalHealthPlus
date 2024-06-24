import "package:cloud_firestore/cloud_firestore.dart";
import 'package:healthsphere/services/service_locator.dart';
import "package:http/http.dart"as http;
import "dart:convert";

class DrugsFirestoreService {

  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  // Retrieve Collection of Drugs
  CollectionReference get drugsCollection {
    return _firebaseFirestore.collection('drugs');
  }

  // Read Drug Database
  Stream<QuerySnapshot> readDrugsStream() {
    return drugsCollection
    .orderBy('genericName')
    .snapshots();
  }

  // Get Drug Document Changes
  Stream<DocumentSnapshot> getDrugsStream(String drugId) {
    return drugsCollection.doc(drugId).snapshots();
  }

  // Check if Drug Exists
  Future<bool> drugExists(String query) async {
    final querySnapshot = await _firebaseFirestore
      .collection('drugs')
      .where('genericAndBrandNames', arrayContains: query)
      .get();
    
    return querySnapshot.docs.isNotEmpty;
  }

  // Filter Drugs by Name
  List<DocumentSnapshot> filterDrugs(List<DocumentSnapshot> drugList, String searchText) {
    if (searchText.isEmpty) {
      return drugList;
    }

    return drugList.where((drug) {
      var names = List<String>.from(drug['genericAndBrandNames']);
      return names
          .any((name) => name.toLowerCase().contains(searchText.toLowerCase()));
    }).toList();
  }

  // Scrape and store Drug Info into Firestore
  Future<Map<String, dynamic>> scrapeDrugInfo(String drugName) async {
    const functionUrl =
        "https://asia-southeast1-orbitalhealthsphere-73d9d.cloudfunctions.net/scrapeDrugs";

    final drugUrl = Uri.encodeComponent(
        "https://patient.info/search?searchterm=$drugName&filters=pageMedicineLeaflet");

    final response = await http.get(Uri.parse("$functionUrl?url=$drugUrl"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to Load Data");
    }
  }
}
