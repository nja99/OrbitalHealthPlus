import "package:cloud_firestore/cloud_firestore.dart";
import 'package:healthsphere/services/service_locator.dart';
import "package:http/http.dart"as http;
import "dart:convert";

class DrugsFirestoreService {

  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  Future<bool> drugExists(String drugName) async {
    final docSnapshot = await _firebaseFirestore
      .collection('drugs')
      .doc(drugName)
      .get();

    return docSnapshot.exists;
  }

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
