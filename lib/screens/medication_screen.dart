import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import "package:healthsphere/components/cards/medication_card.dart";
import "package:healthsphere/components/dialogs/create_medication_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:healthsphere/components/expanded_container.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/services/notification/notification_service.dart";
import "package:healthsphere/utils/time_of_day_extension.dart";

class MedicationScreen extends StatefulWidget {

  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {

  // Fire Store //
  final MedicationFirestoreService firestoreService = getIt<MedicationFirestoreService>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          heroTag: "createMedication",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateMedicationDialog(firestoreService: firestoreService)
              )
            );
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          ExpandedContainer(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 5, 1, 0), 
            child: Column(
              children: [
                _buildListHeader(),
                Expanded(child: _buildMedicationList()),
              ],
            )
          ),
        ],
      ),
    ); 
  }
  
  Widget _buildListHeader() {
    return const Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 14, 14, 8),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text("Time", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text("Medication", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
          )
        ],
      ),
    );
  }

  Widget _buildMedicationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.readMedicationStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> medicationList = snapshot.data!.docs;
          Map<String, List<DocumentSnapshot>> groupedMedications = _groupMedicationByTime(medicationList);

          List<String> sortedTimes = groupedMedications.keys.toList()
            ..sort((a, b) {
              TimeOfDay timeA = TimeOfDayExtension.toTimeOfDay(a);
              TimeOfDay timeB = TimeOfDayExtension.toTimeOfDay(b);
              return timeA.hour != timeB.hour ? timeA.hour.compareTo(timeB.hour) : timeA.minute.compareTo(timeB.minute);
            });
          NotificationService.scheduleMedicationReminders(_currentUser!.uid.hashCode, "It's time to take your Medication! ${_currentUser!.displayName}", sortedTimes);

          return ListView.builder(
            itemCount: sortedTimes.length,
            itemBuilder: (context, index) {
              
              // Retrieve Medications
              String time = sortedTimes[index];
              List<DocumentSnapshot> medications = groupedMedications[time]!;

              // Border Color
              Color borderColor = _getBorderColor(index, sortedTimes);
              
              return _buildMedicationSection(time, medications, borderColor);

            }
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Map<String, List<DocumentSnapshot>> _groupMedicationByTime(List<DocumentSnapshot> medicationList) {
    Map<String, List<DocumentSnapshot>> groupedMedications = {};

    for (var medication in medicationList) {
      List<dynamic> doseTimes = medication['doseTimes'];

      for (var dose in doseTimes) {
        String time = dose['time'];
        if (groupedMedications.containsKey(time)) {
          groupedMedications[time]!.add(medication);
        } else {
          groupedMedications[time] = [medication];
        }
      }
    }

    return groupedMedications;
  }

  Widget _buildMedicationSection(String time, List<DocumentSnapshot> medications, Color borderColor) {

    // Convert Time to 12Hr Format
    TimeOfDay timeOfDay = TimeOfDayExtension.toTimeOfDay(time);
    List<String> timeParts = timeOfDay.to12HourString().split(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time
                Container(
                  width: 50,
                  padding: const EdgeInsetsDirectional.only(top: 5, end: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: borderColor, width: 2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeParts[0],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        timeParts[1],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Medication Cards
                Expanded(
                  child: Column(
                    children: medications.map((medication) {
                      return MedicationCard(
                        medication: medication,
                        isDismissible: true,
                        onDismissed: (direction) {
                          updateMedication(context, medication, time, direction, firestoreService);
                        },
                        status: _getStatusForTime(medication, time),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Color _getBorderColor(int index, List<String> times) {
    if (times.length == 1) {
      return Theme.of(context).colorScheme.primary;
    }

    TimeOfDay now = TimeOfDay.now();
    TimeOfDay currentTime = TimeOfDayExtension.toTimeOfDay(times[index]);
    TimeOfDay nextTime = index < times.length - 1
        ? TimeOfDayExtension.toTimeOfDay(times[index+1])
        : TimeOfDayExtension.toTimeOfDay(times[0]);

    if (index == times.length - 1) {
      if (now.hour > currentTime.hour || now.hour == currentTime.hour && now.minute >= currentTime.minute) {
        return Theme.of(context).colorScheme.primary;
      }
    }

    if (TimeOfDayExtension.isTimeBetween(now, currentTime, nextTime)) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Colors.grey;
    }
  }

  String _getStatusForTime(DocumentSnapshot medication, String time) {
    List<dynamic> doseTimes = medication['doseTimes'];
    for (var dose in doseTimes) {
      if (dose['time'] == time) {
        return dose['status'];
      }
    }
    return 'pending'; // Default status if not found
  }

}

