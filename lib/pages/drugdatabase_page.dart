import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/cards/drug_card.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/database/drugs_firestore_service.dart';


class DrugDatabasePage extends StatefulWidget {
  
  const DrugDatabasePage({super.key});

  @override
  State<DrugDatabasePage> createState() => _DrugDatabasePageState();
}

class _DrugDatabasePageState extends State<DrugDatabasePage> {

  // Fire Store //
  final DrugsFirestoreService firestoreService = getIt<DrugsFirestoreService>();

  // Search Text //
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drug Database"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: "Search Drugs",
            )
          ),
          Expanded(child: _buildDrugList())
        ],
      )
    );
  }

  Widget _buildDrugList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.readDrugsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        List<DocumentSnapshot> drugList = snapshot.data!.docs;

        var filteredList = firestoreService.filterDrugs(drugList, _searchText);

        if (filteredList.isEmpty) {
          return Center(child: Text('No drugs found'));
        }

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {

            // Retrieve Drug Information
            DocumentSnapshot drug = filteredList[index];
            String drugID = drug.id;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DrugCard(drug: drug)
            );
          }
        );

        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
