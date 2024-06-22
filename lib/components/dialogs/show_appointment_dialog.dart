import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/create_appointment_dialog.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";
import "package:healthsphere/themes/custom_text_styles.dart";
import "package:intl/intl.dart";

class ShowAppointmentDialog extends StatefulWidget {

  final DocumentSnapshot appointment;

  const ShowAppointmentDialog({
    super.key,
    required this.appointment
  });

  @override
  State<ShowAppointmentDialog> createState() => _ShowAppointmentDialogState();
}

class _ShowAppointmentDialogState extends State<ShowAppointmentDialog> {
  final AppointmentFirestoreService firestoreService = getIt<AppointmentFirestoreService>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestoreService.getAppointmentStream(widget.appointment.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final title = data['title'] ?? '';
          final description = data['description'] ?? '';
          final location = data['location'] ?? '';

          // Retrieve Timestamp and Convert into Date and Time
          final Timestamp timestamp = data['date_time'];
          final DateTime dateTime = timestamp.toDate();
          final date = DateFormat("dd-MMM-yyyy").format(dateTime);
          final time = DateFormat("HH:mm").format(dateTime);
      
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder
                Align(
                  alignment: Alignment.center,
                  child: Image.asset("lib/assets/images/placeholder.png", height: 180),
                ),
            
                // Appointment Title
                const SizedBox(height: 30),
                Text(
                  title,
                  style: CustomTextStyles.title
                ),

                // Date and Time
                const SizedBox(height: 10),
                Text(date, style: CustomTextStyles.bodyBold),
                Text(time, style: CustomTextStyles.bodyBold),

                // Location
                const SizedBox(height: 10),
                const Text("Location", style: CustomTextStyles.subHeader),
                const SizedBox(height: 10),
                Text(location, style: CustomTextStyles.bodyBold),

                // Detailed Description
                const SizedBox(height: 10),
                const Text("Description", style: CustomTextStyles.subHeader),
                
                const SizedBox(height: 10),
                Text(description, style: CustomTextStyles.bodyNormal),

                // Edit / Delete Buttons
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                      // EDIT BUTTON
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("EDIT"),
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateAppointmentDialog(firestoreService: firestoreService, appointment: widget.appointment)
                              )
                            );
                          }, 
                        ),
                      ),
                    
                      // DELETE BUTTON
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text("DELETE"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await firestoreService.deleteAppointment(widget.appointment.id);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }
}