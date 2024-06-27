import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_remote_config/firebase_remote_config.dart";
import 'package:healthsphere/services/service_locator.dart';
import "package:http/http.dart"as http;
import "dart:convert";

class DrugsFirestoreService {

  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();
  final FirebaseRemoteConfig _remoteConfig = getIt<FirebaseRemoteConfig>();

  DrugsFirestoreService() {
    initializeRemoteConfig();
  }

  // Initialize and fetch Remote Config
  Future<void> initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  // Retrieve Collection of Drugs
  CollectionReference get drugsCollection {
    return _firebaseFirestore.collection('drugs');
  }

  // CRUD //
  // Read Drug Database
  Stream<QuerySnapshot> readDrugsStream() {
    return drugsCollection
    .orderBy('genericName')
    .snapshots();
  }

  // Get Drug Document Changes
  Stream<DocumentSnapshot> getDrugStream(String drugId) {
    return drugsCollection.doc(drugId).snapshots();
  }
  
  // Filters //
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

  Future<List<String>> searchDrugs(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final querySnapshot = await drugsCollection.get();
    final results = querySnapshot.docs
      .map((doc) => List<String>.from(doc['genericAndBrandNames']))
      .expand((names) => names)
      .where((name) => name.toLowerCase().startsWith(query.toLowerCase()))
      .take(3)
      .toList();
    
    return results;
  }

  // Utilities //
  // Check if Drug Exists
  Future<bool> drugExists(String query) async {

    final querySnapshot = await drugsCollection
      .where('genericAndBrandNames', arrayContains: query)
      .get();
    
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> getDrugPurpose (String drugName) async {
    final querySnapshot = await drugsCollection
      .where('genericAndBrandNames', arrayContains: drugName)
      .limit(1)
      .get();

    if (querySnapshot.docs.isNotEmpty) {
      final drugData = querySnapshot.docs.first.data() as Map<String,dynamic>;
      return drugData['drugPurpose'] ?? '';
    }

    return '';
  }

  // External Integration //
  // Scrape and store Drug Info into Firestore
  Future<Map<String, dynamic>> scrapeDrugInfo(String drugName) async {
    final functionUrl =
        _remoteConfig.getString("function_url");

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
