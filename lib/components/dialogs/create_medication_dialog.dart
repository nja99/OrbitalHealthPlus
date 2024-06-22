import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:healthsphere/components/forms/form_dropdown.dart";
import "package:healthsphere/components/forms/form_textfield.dart";
import "package:healthsphere/config/medications_config.dart";
import "package:healthsphere/services/database/drugs_firestore_service.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/services/service_locator.dart";


class CreateMedicationDialog extends StatefulWidget {

  final MedicationFirestoreService firestoreService;
  final DocumentSnapshot? medication;

  const CreateMedicationDialog({
    super.key,
    required this.firestoreService,
    this.medication
  });

  @override
  State<CreateMedicationDialog> createState() => _CreateMedicationDialogState();
}

class _CreateMedicationDialogState extends State<CreateMedicationDialog> {

  final DrugsFirestoreService drugService = getIt<DrugsFirestoreService>();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _medicationName = TextEditingController();
  final TextEditingController _medicationPurpose = TextEditingController();
  final TextEditingController _dosageAmount = TextEditingController();

  String? _dosageRoute = MedicationConfig.routeOptions.first;
  String? _dosageFrequency = MedicationConfig.frequencyOptions.first;
  String? _dosageInstruction = MedicationConfig.instructionOptions.first;

  String get _dosageUnit {
    return MedicationConfig.getDosageUnit(_dosageRoute);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveMedication() async {

    if (_formKey.currentState!.validate()) {
      String name = _medicationName.text;
      String purpose = _medicationPurpose.text;
      String amount = _dosageAmount.text;

      final exists = await drugService.drugExists(name);

      if(!exists) {
        print("scraping drug");
        try { 
          await drugService.scrapeDrugInfo(name);
        } catch (e) {
          print("Failed to scrape :$e");
        }
      }

      if (widget.medication != null) {
        /*
        widget.firestoreService.updateMedication(name, newTitle, newDescription, newLocation, newFormattedDateTime, status)
          // Pop Dialog
          .then ((_) { Navigator.of(context).pop(); })
          .catchError((error) { print("Failed to update medication: $error"); });
        */
      } else {
        widget.firestoreService.addMedication(name, purpose, _dosageRoute, amount, _dosageUnit, _dosageFrequency, _dosageInstruction)
          // Pop Dialog
          .then((_) { Navigator.of(context).pop(); })
          .catchError((error) { print("Failed to add medication: $error"); });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication != null
          ? "Update Medication"
          : "Add Medication"
        ),
      ),
      body: SafeArea(
        child:  ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    // Title Field
                    FormTextField(
                      controller: _medicationName, 
                      title: "Medicine Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a medication";
                        }
                        return null;
                      }
                    ),
                    // Purpose Field (Auto-fill?)
                    FormTextField(
                      controller: _medicationPurpose,
                      title: "Purpose",
                      maxLines: 3,
                    ),

                    // Dosage Route & Amount
                    Row(
                      children: [
                        // Dosage Route
                        Expanded(
                          child: FormDropdown(
                            title: "Route",
                            value: _dosageRoute,
                            onSelected: (newValue) {
                              setState(() {
                                _dosageRoute = newValue;
                              });
                            },
                            items: MedicationConfig.routeOptions,
                          ),
                        ),

                        // Dosage Amount
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_dosageRoute == "Topical")
                                Container(
                                  padding: const EdgeInsets.only(top:25),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Apply As Needed",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  )
                                )
                              else 
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormTextField(
                                        controller: _dosageAmount,
                                        title: "Amount",
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 25),
                                        alignment: Alignment.center,
                                        child: Text(
                                          MedicationConfig.getDosageUnit(_dosageRoute),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      )
                                    )
                                  ]
                                )
                            ],
                          ),
                        )
                      ],
                    ),

                    // Dosage Frequency
                    FormDropdown(
                      title: "Frequency", 
                      value: _dosageFrequency, 
                      onSelected: (newValue) {
                        setState(() {
                          _dosageFrequency = newValue;
                        });
                      }, 
                      items: MedicationConfig.frequencyOptions
                    ),

                    // Instructions
                    FormDropdown(
                      title: "Instructions", 
                      value: _dosageInstruction, 
                      onSelected: (newValue) {
                        setState(() {
                          _dosageInstruction = newValue;
                        });
                      }, 
                      items: MedicationConfig.instructionOptions
                    ),
/*
                    // First Dose
                    DateTimeWidget(
                      title: "First Dose",
                      value: value,
                      icon: icon,
                      onTap: onTap
                    ),
*/
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _saveMedication,
                        child: const Text("Test")
                      ),
                    )
                    //
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}