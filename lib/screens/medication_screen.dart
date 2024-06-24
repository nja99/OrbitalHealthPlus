import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/cards/medication_card.dart";
import "package:healthsphere/components/dialogs/create_medication_dialog.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/utils/time_of_day_extension.dart";

class MedicationScreen extends StatefulWidget {

  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {

  // Fire Store //
  final MedicationFirestoreService firestoreService = getIt<MedicationFirestoreService>();

  // Text Controller //
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "createMedication",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateMedicationDialog(
                firestoreService: firestoreService
              )
            )
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF4B39EF),
        ),
      ),
      body: _buildMedicationList(),
    ); 
  }

  Widget _buildMedicationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.readMedicationStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> medicationList = snapshot.data!.docs;
          Map<String, List<DocumentSnapshot>> groupedMedications = {};

          for (var medication in medicationList) {
            List<dynamic> doseTimes = medication['doseTimes'];

            for (var time in doseTimes) {
              if (groupedMedications.containsKey(time)) {
                groupedMedications[time]!.add(medication);
              } else {
                groupedMedications[time] = [medication];
              }
            }
          }

          return ListView.builder(
            itemCount: groupedMedications.keys.length + 1,
            itemBuilder: (context, index) {
              // List Header
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(14, 14, 14, 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text("Time", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Medication", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      )
                    ],
                  ),
                );
              } else {
                // Retrieve Medications
                String time = groupedMedications.keys.elementAt(index - 1);
                List<DocumentSnapshot> medications = groupedMedications[time]!;
                TimeOfDay timeOfDay = TimeOfDayExtension.toTimeOfDay(time);

                List<String> timeParts = timeOfDay.to12HourString().split(' ');
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Time
                          Container(
                            width: 60,
                            padding: const EdgeInsetsDirectional.only(top: 8, end: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  timeParts[0],
                                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  timeParts[1],
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ),

                          // Medication Cards
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: medications.map((medication) {
                                return MedicationCard(
                                  medication: medication, 
                                  isDismissible: true,
                                  onDismissed: (direction) {
                                  }
                                );
                              }).toList(),
                            )
                          )
                        ],
                      )
                    ),
                  ]
                );
              }
            }
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}

