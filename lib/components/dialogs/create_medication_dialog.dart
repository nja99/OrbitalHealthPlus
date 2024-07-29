import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:healthsphere/components/date_time_widget.dart";
import "package:healthsphere/components/forms/form_dropdown.dart";
import "package:healthsphere/components/forms/form_textfield.dart";
import "package:healthsphere/config/medications_config.dart";
import "package:healthsphere/services/database/drugs_firestore_service.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/services/service_locator.dart";
import "package:healthsphere/utils/time_of_day_extension.dart";
import "package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart" as dtpicker;



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
  String _dosageUnit = "";
  TimeOfDay? _firstDose;

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      final data = widget.medication!.data() as Map<String,dynamic>;
      _medicationName.text = data['name'] ?? '';
      _medicationPurpose.text = data['purpose'] ?? '';
      _dosageAmount.text = data['amount'] ?? '';
      _dosageRoute = data['route'] ?? '';
      _dosageUnit = MedicationConfig.getDosageUnit(_dosageRoute);
      _dosageFrequency = data['frequency'];
      _dosageInstruction = data['instruction'];
      _firstDose = TimeOfDayExtension.toTimeOfDay(data['firstDose']);
    } else {
      _firstDose = const TimeOfDay(hour: 8, minute: 30);
      _dosageUnit = MedicationConfig.getDosageUnit(_dosageRoute);
    }
  }

  @override
  void dispose() {
    _medicationName.dispose();
    _medicationPurpose.dispose();
    _dosageAmount.dispose();
    super.dispose();
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String name = _medicationName.text;
      String purpose = _medicationPurpose.text;
      String amount = _dosageAmount.text;

      final exists = await drugService.drugExists(name);

      if(!exists) {
        print("scraping drug");
        drugService.scrapeDrugInfo(name).catchError((e) {
          print("Failed to Scrape: $e");
          return <String,dynamic> {};
        });
      }

      int frequency = MedicationConfig.frequencyOptions.indexOf(_dosageFrequency!) + 1;
      double interval = 24 / frequency;

      // Generate dose times
      List<Map<String,String>> doseTimes = [];
      for (int i = 0; i < frequency; i++) {
        TimeOfDay doseTime = _firstDose!.replacing(hour: (_firstDose!.hour + (interval * i).floor()) % 24);
        doseTimes.add({"time": doseTime.to24HourString(), "status": "pending"});
      }

      final medicationData = widget.firestoreService.constructMedicationData(
        name: name,
        purpose: purpose,
        route: _dosageRoute!,
        amount: amount,
        unit: _dosageUnit,
        frequency: _dosageFrequency!,
        instruction: _dosageInstruction!,
        firstDose: _firstDose!.to24HourString(),
        doseTimes: doseTimes, // Store as "HH:mm"
        taken: widget.medication != null ? (widget.medication!.data() as Map<String,dynamic>)['taken'] : 0,
        missed: widget.medication != null ? (widget.medication!.data() as Map<String,dynamic>)['missed'] : 0,
      );

      if (widget.medication != null) {
        widget.firestoreService.updateMedication(widget.medication!.id, medicationData)
          // Pop Dialog
          .then((_) { Navigator.of(context).pop(); })
          .catchError((error) { print("Failed to add medication: $error"); });
      } else {
        widget.firestoreService.addMedication(medicationData)
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
                      maxLines: 2,
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
                                _dosageUnit = MedicationConfig.getDosageUnit(_dosageRoute);
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
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  )
                                )
                              else 
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: FormTextField(
                                        controller: _dosageAmount,
                                        title: "Amount",
                                        validator: (value) { 
                                          if (value == null || value.isEmpty) {
                                            return "Enter Amount";
                                          } else if (num.tryParse(value) == null) {
                                            return "Invalid Amount";
                                          }
                                          
                                          return null;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 12, top: 25),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          MedicationConfig.getDosageUnit(_dosageRoute),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
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

                    // First Dose
                    DateTimeWidget(
                      title: "First Dose",
                      value: _firstDose!.format(context),
                      icon: Icons.access_time,
                      onTap: () {
                        dtpicker.DatePicker.showTime12hPicker(
                          context,
                          showTitleActions: true,
                          onChanged: (time) {
                            setState(() {
                              _firstDose = TimeOfDay.fromDateTime(time);
                            });
                          },
                          currentTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 30),
                          theme: const dtpicker.DatePickerTheme(
                            containerHeight: 400,
                          )
                        );
                      }
                    ),
                  ],
                ),
              )
            ),
            // Add / Update Medication
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveMedication,
                child: Text(widget.medication == null
                    ? "Add Medication"
                    : "Update Medication"),
              ),
            )
          ],
        ),
      )
    );
  }
}