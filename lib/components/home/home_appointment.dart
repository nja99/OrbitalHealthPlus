import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/database/appointment_firestore_service.dart';
import 'package:intl/intl.dart';

class HomeAppointment extends StatefulWidget {
  final Function(int) onCategorySelected;

  const HomeAppointment({
    super.key,
    required this.onCategorySelected
    });

  @override
  State<HomeAppointment> createState() => _HomeAppointmentState();
}

class _HomeAppointmentState extends State<HomeAppointment> {
  
  final AppointmentFirestoreService firestoreService = getIt<AppointmentFirestoreService>();

  bool _isLoading = true;
  late Stream<DocumentSnapshot?> _appointmentStream;
  late DocumentSnapshot? _firstAppointment;


  @override
  void initState() {
    super.initState();
    _appointmentStream = firestoreService.getUpcomingPendingAppointmentStream();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Appointments',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {widget.onCategorySelected(2);},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600, 
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<DocumentSnapshot?>(
          stream: _appointmentStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _firstAppointment = snapshot.data;
              return AppointmentPreviewCard(appointment: _firstAppointment);
            }
          },
        )
      ],
    );
  }
}

class AppointmentPreviewCard extends StatelessWidget {

  final DocumentSnapshot? appointment;

  const AppointmentPreviewCard({
    super.key,
    this.appointment
  });

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 125,
        decoration: appointment == null
          ? BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onSecondaryFixedVariant,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
          : null,
        child: appointment != null
          ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                appointment!['title'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${_formatDate(appointment!['date_time'])}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              Text(
                'Location: ${appointment!['location']}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              // Add more details as needed
            ],
          ),
        )
      : Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No Upcoming Appointments',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}