import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/cards/medication_card.dart";
import "package:healthsphere/components/dialogs/create_medication_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:healthsphere/functions/schedule_daily_reset.dart";
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

  @override
  void initState() {
    super.initState();
    DailyResetScheduler().scheduledDailyReset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "createMedication",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateMedicationDialog(firestoreService: firestoreService)
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
          Map<String, List<DocumentSnapshot>> groupedMedications = _groupMedicationByTime(medicationList);

          List<String> sortedTimes = groupedMedications.keys.toList()
            ..sort((a, b) {
              TimeOfDay timeA = TimeOfDayExtension.toTimeOfDay(a);
              TimeOfDay timeB = TimeOfDayExtension.toTimeOfDay(b);
              return timeA.hour != timeB.hour ? timeA.hour.compareTo(timeB.hour) : timeA.minute.compareTo(timeB.minute);
            });

          return ListView.builder(
            itemCount: sortedTimes.length + 1,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: Text("Medication", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      )
                    ],
                  ),
                );
              } else {
                // Retrieve Medications
                String time = sortedTimes[index - 1];
                List<DocumentSnapshot> medications = groupedMedications[time]!;

                // Border Color
                Color borderColor = _getBorderColor(index, sortedTimes);
                
                return _buildMedicationSection(time, medications, borderColor);
              }
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
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeParts[1],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
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
      return Colors.blue;
    }

    TimeOfDay now = TimeOfDay.now();
    TimeOfDay currentTime = TimeOfDayExtension.toTimeOfDay(times[index - 1]);
    TimeOfDay nextTime = index < times.length
        ? TimeOfDayExtension.toTimeOfDay(times[index])
        : TimeOfDayExtension.toTimeOfDay(times[0]);

    if (_isTimeBetween(now, currentTime, nextTime)) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  bool _isTimeBetween(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
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

