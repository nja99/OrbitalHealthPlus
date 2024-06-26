import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/show_medication_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:healthsphere/config/medications_config.dart";

class MedicationCard extends StatelessWidget {

  final DocumentSnapshot medication;
  final Function(DismissDirection) onDismissed;
  final bool isDismissible;
  final String status;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDismissed,
    required this.isDismissible,
    this.status = "pending"
  });

  @override
  Widget build(BuildContext context) {

    // Get Medication Details
    Map<String, dynamic> data = medication.data() as Map<String, dynamic>;
    String name = data['name'];
    String amount = data['amount'];
    String unit = data['unit'];
    String route = data['route'];
    String instruction = data['instruction'];

    Color cardColor;

    if (status == 'taken') {
      cardColor = const Color(0xFFE6F1D9);
    } else if (status == 'missed') {
      cardColor = const Color(0xFFEFDADA);
    } else {
      cardColor = const Color(0xFFE5E8F7);
    }

    return SizedBox(
      height: 80,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: DismissibleWidget( 
          item: medication, 
          onDismissed: onDismissed, 
          isDismissible: isDismissible,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xFFC5D4FA)),
                      child: Image.asset(MedicationConfig.getRouteIcon(route), height: 40)
                    ),
                  ]
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 85,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xFFC5D4FA)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text("$amount $unit", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                          )
                        ),
                        const SizedBox(width: 10),
                        if (instruction != "No Specific Instructions")
                          Container(
                            width: 120,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xFFC5D4FA)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(instruction,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                            )
                          )
                      ],
                    )
                  ],
                ),
              ]
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ShowMedicationDialog(medication: medication))
              );
            },
          )
        ),
      ),
    );
  }
}