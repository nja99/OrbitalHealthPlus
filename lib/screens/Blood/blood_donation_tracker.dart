import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthsphere/assets/model/appointment.dart';
import 'package:intl/intl.dart';
import 'package:healthsphere/services/appointment_service.dart';


class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool showUpcoming = true;
  List<Appointment> appointments = [];
  final AppointmentService appointmentService = AppointmentService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
  setState(() {
    isLoading = true;
  });
  final loadedAppointments = await appointmentService.getAppointments();
  print('Loaded appointments: $loadedAppointments');
  setState(() {
    appointments = loadedAppointments;
    isLoading = false;
  });
}

  List<Appointment> get upcomingAppointments {
  final now = DateTime.now();
  return appointments.where((appointment) => 
    appointment.dateTime != null && appointment.dateTime!.isAfter(now)
  ).toList();
}

List<Appointment> get pastAppointments {
  final now = DateTime.now();
  return appointments.where((appointment) => 
    appointment.dateTime != null && appointment.dateTime!.isBefore(now)
  ).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('Upcoming'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: showUpcoming ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => setState(() => showUpcoming = true),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text('Past'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: !showUpcoming ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => setState(() => showUpcoming = false),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                    ? Center(child: Text('No appointments found'))
                    : ListView.builder(
                        itemCount: showUpcoming ? upcomingAppointments.length : pastAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = showUpcoming ? upcomingAppointments[index] : pastAppointments[index];
                          return _buildAppointmentCard(appointment);
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
 Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          if (appointment.location != null)
            Container(
              height: 150,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: appointment.location!,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(appointment.id),
                    position: appointment.location!,
                  ),
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Donation Type: ${appointment.donationType}'),
                if (appointment.dateTime != null)
                  Text('Date: ${DateFormat('dd-MMM-yyyy').format(appointment.dateTime!)}'),
                if (appointment.dateTime != null)
                  Text('Time: ${DateFormat('HH:mm').format(appointment.dateTime!)}'),
                Text('City: ${appointment.city}'),
                Text('Facility: ${appointment.facility}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              child: Text('Cancel Appointment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: () => _cancelAppointment(appointment),
            ),
          ),
        ],
      ),
    );
  }
  

  Future<void> _cancelAppointment(Appointment appointment) async {
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Cancel Appointment'),
      content: Text('Are you sure you want to cancel this appointment?'),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirm) {
    await appointmentService.cancelAppointment(appointment.id);
    _loadAppointments();
  }
}
}