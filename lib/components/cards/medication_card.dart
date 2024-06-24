import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dimissible_widget.dart";

class MedicationCard extends StatelessWidget {

  final DocumentSnapshot medication;
  final Function(DismissDirection) onDismissed;
  final bool isDismissible;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDismissed,
    required this.isDismissible
  });

  @override
  Widget build(BuildContext context) {

    // Get Medication Details
    Map<String, dynamic> data = medication.data() as Map<String, dynamic>;
    String name = data['name'];
    String amount = data['amount'];
    String unit = data['unit'];
    String purpose = data['purpose'];
    String instruction = data['instruction'];

    return Card(
      color: const Color(0xFFE5E8F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: DismissibleWidget( 
        item: medication, 
        onDismissed: onDismissed, 
        isDismissible: isDismissible,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  Text(
                    "$amount $unit",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  )
                ],
              )
            ],
          )
        )),
    );
  }
}