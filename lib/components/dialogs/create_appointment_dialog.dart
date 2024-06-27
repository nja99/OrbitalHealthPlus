import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/date_time_widget.dart";
import "package:healthsphere/components/forms/form_textfield.dart";
import "package:healthsphere/screens/map_screen.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";
import "package:healthsphere/utils/time_of_day_extension.dart";
import "package:intl/intl.dart";
import "package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart" as dtpicker;

class CreateAppointmentDialog extends StatefulWidget {
  
  final AppointmentFirestoreService firestoreService;
  final DocumentSnapshot? appointment;
  
  const CreateAppointmentDialog({
    super.key,
    required this.firestoreService,
    this.appointment
  });

  @override
  State<CreateAppointmentDialog> createState() => _CreateAppointmentDialogState();
}

class _CreateAppointmentDialogState extends State<CreateAppointmentDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String location = '';

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      final data = widget.appointment!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _locationController.text = data['location'] ?? '';
      
      // Retrieve and convert Timestamp to Date
      Timestamp timestamp = data['date_time'];
      _selectedDate = timestamp.toDate();
      _selectedTime = _selectedDate != null ? TimeOfDay.fromDateTime(_selectedDate!) : null;
    } else {
      _selectedTime = const TimeOfDay(hour: 8, minute: 30);
      _selectedDate = _selectedTime!.toDateTime(DateTime.now());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {

      // If form is valid, save appointment
      String title = _titleController.text;
      String description = _descriptionController.text;
      String location = _locationController.text;
      String status = "Upcoming";

      // Combine Date and Time into DateTime Object
      DateTime appointmentDateTime = _selectedTime!.toDateTime(_selectedDate!);

      // Format Date and Time for Storage
      Timestamp formattedDateTime = Timestamp.fromDate(appointmentDateTime);

      final appointmentData = widget.firestoreService.constructAppointmentData(
        title: title,
        description: description, 
        dateTime: formattedDateTime,
        location: location,
        status: status
      );

      
      if (widget.appointment != null) {
        // Update Appointment in DB        
        widget.firestoreService.updateAppointment(widget.appointment!.id, appointmentData)
          // Pop Dialog
          .then((_) { Navigator.of(context).pop();})
          .catchError((error) {print("Failed to update appointment: $error");});
      } else {
        // Add Appointment to DB
        widget.firestoreService.addAppointment(appointmentData)
          // Pop Dialog
          .then((_) { Navigator.of(context).pop();})
          .catchError((error) {print("Failed to add appointment: $error");});
      }
    }
  }



  Future<void> _pickLocation() async {
    // Navigate to the MapScreen and await the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    // If a result was returned, update the location
    if (result != null && result is String) {
      setState(() {
        location = result;
        _locationController.text = location; // Set result to controller
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment != null
          ? "Update Appointment"
          : "Create Appointment"
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    // Title Field
                    FormTextField(
                      controller: _titleController,
                      title: "Title",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a title";
                        }
                        return null;
                      },  
                    ),

                    // Description Field
                    FormTextField(
                      controller: _descriptionController, 
                      title: "Description",
                      maxLines: 7,
                    ),

                    // Location Field
                    FormTextField(
                      controller: _locationController,
                      title: "Location",
                      prefixIcon: GestureDetector(
                        onTap: _pickLocation,
                        child: const Icon(Icons.location_on),
                      )
                    ),
                    // Date Field
                    DateTimeWidget(
                      title: "Date",
                      value: DateFormat("dd-MMM-yyyy").format(_selectedDate!),
                      icon: Icons.calendar_month, 
                      onTap: (){
                        dtpicker.DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          onChanged: (date) {
                            setState(() {
                              _selectedDate = _selectedTime!.toDateTime(date);
                            });
                          },
                          currentTime: _selectedDate ?? DateTime.now(),
                          theme: const dtpicker.DatePickerTheme(
                            containerHeight: 400,
                          )
                        );
                      },
                    ),

                    // Time Field
                    DateTimeWidget(
                      title: "Time", 
                      value: _selectedTime!.format(context),
                      icon: Icons.access_time, 
                      onTap: (){
                        dtpicker.DatePicker.showTime12hPicker(
                          context,
                          showTitleActions: true,
                          onChanged: (time) {
                            setState(() {
                              _selectedTime = TimeOfDay.fromDateTime(time);
                            });
                          },
                          currentTime: _selectedDate,
                          theme: const dtpicker.DatePickerTheme(
                            containerHeight: 400,
                          )
                        );
                      },
                    ),
                  ],
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveAppointment,
                child: Text(widget.appointment == null 
                  ? "Create Appointment"
                  : "Update Appointment"),
              ))
          ] 
        )
      )
    );
  }
}