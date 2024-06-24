import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/cards/appointment_card.dart";
import "package:healthsphere/components/dialogs/create_appointment_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
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
    
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "createAppointment",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateAppointmentDialog(
                  firestoreService: firestoreService,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Color(0xFF4B39EF),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
                Tab(text: "Missed")
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAppointmentList("Upcoming"),
                  _buildAppointmentList("Completed"),
                  _buildAppointmentList("Missed")
                ],
              )
            )
          ],
        )
      ),
    );
  }

  bool _isDismissible (String status) {
    return status == "Upcoming";
  }

  Widget _buildAppointmentList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.readAppointmentStream(), 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> appointmentList = snapshot.data!.docs
              .where((doc) => doc['status'] == status)
              .toList();
          
          return ListView.builder(
            itemCount: appointmentList.length,
            itemBuilder: (context, index) {
              
              // Retrieve Appointments
              DocumentSnapshot appointment = appointmentList[index];
              String appointmentID = appointment.id;

              // Retrieve Year of Appointment
              Timestamp timestamp = appointment['date_time'];
              DateTime appointmentDate = timestamp.toDate();
              int year = appointmentDate.year;

              // Check If Year Divider is Required
              bool showYearDivider = index == 0 || (appointmentList[index - 1]['date_time'] as Timestamp).toDate().year != year;

              // Display Appointment in List Tiles
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Year Divider
                  if (showYearDivider)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: Text(year.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AppointmentCard(
                      appointment: appointment,
                      isDismissible: _isDismissible(status),
                      onDismissed: (direction) {
                        setState(() {
                          dismissItem(context, appointmentList, index, direction, firestoreService);
                        });
                      },
                    ),
                  )
                ],
              );
            }
          );
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }


}