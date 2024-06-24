import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/show_drug_dialog.dart";

class DrugCard extends StatelessWidget {

  final DocumentSnapshot drug;

  const DrugCard({
    super.key,
    required this.drug,
  });

  @override
  Widget build(BuildContext context) {

    // Get Drug Details
    Map<String,dynamic> data = drug.data() as Map<String,dynamic>;
    String name = data['genericName'];
    String type = data['drugType'];

    return Card(
      color: const Color(0xFFE5E8F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ShowDrugDialog(drug: drug))
          );
        },
      )
    );
  }


}
