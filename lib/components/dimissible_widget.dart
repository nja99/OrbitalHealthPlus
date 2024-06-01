import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";

class DismissibleWidget<T> extends StatelessWidget {

  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget({
    super.key,
    required this.child,
    required this.item,
    required this.onDismissed
  });

  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Dismissible(
        key: ObjectKey(item),
        background: buildSwipeActionLeft(),
        secondaryBackground: buildSwipeActionRight(),
        onDismissed: onDismissed,
        child: child,
      )
    );
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

  switch (direction) {
    case DismissDirection.startToEnd:
      firestoreService.updateAppointmentStatus(appointmentID, "Completed")
      .then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Appointment Completed')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete appointment: $error')));
      });
      break;
    case DismissDirection.endToStart:
      // Handle Right to Left
      firestoreService.updateAppointmentStatus(appointmentID, "Missed")
      .then((_) {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Appointment Missed')));
      })
      .catchError((error) {
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Failed to delete appointment: $error')));
      });
      break;
    default:
      break;
  }
}

