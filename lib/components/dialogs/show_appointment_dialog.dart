import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";

class ShowAppointmentDialog extends StatelessWidget {

  
  final AppointmentFirestoreService firestoreService = getIt<AppointmentFirestoreService>();
  final DocumentSnapshot appointment;

  ShowAppointmentDialog({
    super.key,
    required this.appointment
  });

  @override
  Widget build(BuildContext context) {
    final data = appointment.data() as Map<String, dynamic>;
    final title = data['title'] ?? '';
    final description = data['description'] ?? '';
    final location = data['location'] ?? '';
    final date = data['date'] ?? '';
    final time = data['time'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}