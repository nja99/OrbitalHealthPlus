import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/create_medication_dialog.dart";
import "package:healthsphere/config/medications_config.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/drugs_firestore_service.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/themes/custom_text_styles.dart";

class ShowMedicationDialog extends StatefulWidget {

  final DocumentSnapshot medication;

  const ShowMedicationDialog({
    super.key,
    required this.medication
    });

  @override
  State<ShowMedicationDialog> createState() => _ShowMedicationDialogState();
}

class _ShowMedicationDialogState extends State<ShowMedicationDialog> {

  final MedicationFirestoreService firestoreService = getIt<MedicationFirestoreService>();
  final DrugsFirestoreService drugFirestoreService = getIt<DrugsFirestoreService>();

  Future<String> _getDrugPurpose(String? purpose, String name) async {
    if (purpose != null && purpose.isNotEmpty) {
      return purpose;
    }
    return await drugFirestoreService.getDrugPurpose(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestoreService.getMedicationStream(widget.medication.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child:  CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'] ?? '';
          final route = data['route'] ?? '';
          final amount = data['amount'] ?? '';
          final unit = data['unit'] ?? '';
          final instruction = data['instruction'] ?? '';
          final frequency = data['frequency'] ?? '';
          final doseTimes = List<Map<String,dynamic>>.from(data['doseTimes'] ?? []);

          return FutureBuilder<String>(
            future: _getDrugPurpose(data['purpose'], name),
            builder: (context, purposeSnapshot) {
              
              if (purposeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final purpose = purposeSnapshot.data ?? '';
              
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route Icon
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(MedicationConfig.getRouteImage(route), height:180)
                    ),
              
                    // Medication Name
                    const SizedBox(height: 30),
                    Text(
                      name,
                      style: CustomTextStyles.title,
                    ),
              
                    // Route & Dosage Information
                    Text("Route: $route", style: CustomTextStyles.bodyBold),
                    Text("Amount: $amount $unit", style: CustomTextStyles.bodyBold),
              
                    // Medication Purpose
                    if (purpose.isNotEmpty) ... [
                      const SizedBox(height: 10),
                      const Text("Purpose", style: CustomTextStyles.subHeader, textAlign: TextAlign.justify),
                      Text(
                        purpose,
                        style: CustomTextStyles.bodyBold,
                      )
                    ],
              
                    if (instruction != "No Specific Instructions") ...[
                      const SizedBox(height: 10),
                      const Text("Instructions", style: CustomTextStyles.subHeader),
                      Text(
                        instruction,
                        style: CustomTextStyles.bodyBold,
                      )
                    ],
              
                    // Dose Frequency and Timing
                    const SizedBox(height: 10),
                    const Text("Frequency", style:CustomTextStyles.subHeader),
                    Text(frequency, style: CustomTextStyles.bodyBold),
              
                    const SizedBox(height: 10),
                    const Text("Timing(s)", style: CustomTextStyles.subHeader),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: doseTimes.map((dose) {
                        final time = dose['time'] ?? '';
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Icon(Icons.brightness_1, size: 6)
                            ),
                            const SizedBox(width: 7),
                            Expanded(child: Text(time, style: CustomTextStyles.bodyBold))
                          ]
                        );
                      }).toList(),
                    ),
              
                    // Edit / Delete Buttons
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Edit Button
                          Expanded(
                            child: ElevatedButton(
                              child: const Text("EDIT"),
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => CreateMedicationDialog(firestoreService: firestoreService, medication: widget.medication))
                                );
                                setState(() {});
                              },
                            ),
                          ),
              
                          // Delete Button
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              child: const Text("DELETE"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await firestoreService.deleteMedication(widget.medication.id);
                              },
                            ),
                          )
                        ],
                      ),
                    )
              
                  ],
                ),
              );
            }
          );
        },
      ),
    );
  }
}