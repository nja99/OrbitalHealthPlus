import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:healthsphere/components/dialogs/show_appointment_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:intl/intl.dart";

class AppointmentCard extends StatelessWidget {
  
  final DocumentSnapshot appointment;
  final Function(DismissDirection) onDismissed;
  final bool isDismissible;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onDismissed,
    required this.isDismissible
    
  });

  @override
  Widget build(BuildContext context) {
    
    // Get Appointment Details
    Map<String, dynamic> data = appointment.data() as Map<String, dynamic>;
    String title = data['title'];
    Timestamp dateTime = data['date_time'];

    // Parse DateTime
    DateTime appointmentDateTime = dateTime.toDate();
    String day = DateFormat('dd').format(appointmentDateTime);
    String month = DateFormat('MMM').format(appointmentDateTime);
    String time = DateFormat('HH:mm').format(appointmentDateTime);

    return Card(
      color: const Color(0xFFFFFEFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: DismissibleWidget<DocumentSnapshot>(
          item: appointment,
          onDismissed: onDismissed,
          isDismissible: isDismissible,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      month,
                      style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)
                    )
                  ],
                ),
                Container(
                  width: 2,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.black,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        time,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ))
              ]
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ShowAppointmentDialog(appointment: appointment))
              );
            }
          )
      ),
    );
  }
}