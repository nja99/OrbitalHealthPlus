import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/create_medication_dialog.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";

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
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
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
      ) 
    );
  }
}