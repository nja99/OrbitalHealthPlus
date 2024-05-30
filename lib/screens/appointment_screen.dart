import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/dialogs/create_appointment_dialog.dart";
import "package:healthsphere/components/cards/custom_card.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:healthsphere/components/dialogs/show_appointment_dialog.dart";
import "package:healthsphere/services/auth/auth_service_locator.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // Fire Store //
  final AppointmentFirestoreService firestoreService = getIt<AppointmentFirestoreService>();

  // Text Controller //
  final TextEditingController textController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "createAppointment" ,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => 
                CreateAppointmentDialog(
                  firestoreService: firestoreService
                )
            )
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFF4B39EF),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.readAppointmentStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<DocumentSnapshot> appointmentList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: appointmentList.length,
              itemBuilder: (context, index) {
                // Retrieve Appointments
                DocumentSnapshot appointment = appointmentList[index];
                String appointmentID = appointment.id;

                // Get Appointments Detail
                Map<String, dynamic> data = appointment.data() as Map<String, dynamic>;
                String appointmentData = data['appointment'];

                // Display Appointment in List Tiles
                return CustomCard(
                  child: DismissibleWidget<DocumentSnapshot>(
                    item: appointment,
                    onDismissed: (direction) {
                      setState(() {
                        dismissItem(context, appointmentList, index, direction, firestoreService);
                      });
                    },
                    child: ListTile(
                      title: Text(appointmentData),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ShowAppointmentDialog(appointment: appointment))
                        );
                      },
                    )
                  )
                );
              }
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }


}