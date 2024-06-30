import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:healthsphere/services/database/appointment_firestore_service.dart";
import "package:healthsphere/services/database/medications_firestore_service.dart";
import "package:healthsphere/utils/show_snackbar.dart";

class DismissibleWidget<T> extends StatelessWidget {

  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final bool isDismissible;

  const DismissibleWidget({
    super.key,
    required this.child,
    required this.item,
    required this.onDismissed,
    required this.isDismissible
  });

  @override
  Widget build(BuildContext context){
    return isDismissible
    ?  ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Dismissible(
          key: ObjectKey(item),
          background: buildSwipeActionLeft(),
          secondaryBackground: buildSwipeActionRight(),
          onDismissed: onDismissed,
          child: child,
        )
      )
    : child;
  }

  Widget buildSwipeActionLeft() => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.green,
    child: const Icon(Icons.check, color: Colors.white, size: 32,)
  );

  Widget buildSwipeActionRight() => Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: const Icon(
      Icons.cancel,
      color: Colors.white,
      size: 32,
    )
  );
  
}

void dismissItem(BuildContext context, List<DocumentSnapshot> items, int index, DismissDirection direction, AppointmentFirestoreService firestoreService){
  DocumentSnapshot appointment = items[index];
  String appointmentID = appointment.id;
  String status;

  switch (direction) {
    case DismissDirection.startToEnd:
      // Handle Left to Right
      status = "Completed";
      break;
    case DismissDirection.endToStart:
      // Handle Right to Left
      status = "Missed";
      break;
    default:
      return;
  }
  firestoreService.updateAppointmentStatus(appointmentID, status)
    .then((_) => showSnackBar(context, "Appointment $status"))
    .catchError((error) => showSnackBar(context, "Failed to delete appointment: $error"));
}

void updateMedication (BuildContext context, DocumentSnapshot medication, String doseTime, DismissDirection direction, MedicationFirestoreService firestoreService,) {
  String medicationID = medication.id;
  String status;

  switch (direction) {
    case DismissDirection.startToEnd:
      status = "taken";
      break;
    case DismissDirection.endToStart:
      status = "missed";
      break;
    default:
      return;
  }
  firestoreService.updateDoseStatus(medicationID, doseTime, status)
    .then((_) => showSnackBar(context, "Medication $status"))
    .catchError((error) => showSnackBar(context, "Error updating status"));
}



