import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import "package:healthsphere/components/cards/appointment_card.dart";
import "package:healthsphere/components/dialogs/create_appointment_dialog.dart";
import "package:healthsphere/components/dimissible_widget.dart";
import "package:healthsphere/components/expanded_container.dart";
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

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
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
            elevation: 5,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            ExpandedContainer(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 10),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: TabBar(
                        tabs: const  [
                          Tab(text: "Upcoming"),
                          Tab(text: "Completed"),
                          Tab(text: "Missed")
                        ],
                        splashFactory: NoSplash.splashFactory,
                        unselectedLabelColor: Theme.of(context).colorScheme.onTertiary,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(3),
                        indicator: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        
                      ),
                    ),
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
              ),
            ),
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
                      child: Center(child: Text(year.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
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