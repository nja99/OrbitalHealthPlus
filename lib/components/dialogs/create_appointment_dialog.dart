import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/forms/form_textfield.dart";
import "package:healthsphere/services/database/appointment_firestore_service.dart";
import "package:intl/intl.dart";

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

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      final data = widget.appointment!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _locationController.text = data['location'] ?? '';
      _selectedDate = DateTime.tryParse(data['date'] ?? '');
      _selectedTime = _selectedDate != null ? TimeOfDay.fromDateTime(_selectedDate!) : null;
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {

      // If form is valid, save appointment
      String title = _titleController.text;
      String description = _descriptionController.text;
      String location = _locationController.text;

      // Combine Date and Time into DateTime Object
      DateTime appointmentDateTime = _selectedDate!.add(Duration(hours: _selectedTime!.hour, minutes: _selectedTime!.minute));

      // Format Date and Time for Storage
      String formattedDateTime = appointmentDateTime.toIso8601String();

      // Add appointment to DB
      widget.firestoreService.addAppointment(title, description, location, formattedDateTime)
        // Pop Dialog
        .then((_) {
          Navigator.of(context).pop();
        })
        // If Error print error message
        .catchError((error) {
          print("Failed to add appointment: $error");
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Appointment"),
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
                    FormTextField(
                      controller: _descriptionController, 
                      title: "Description",
                      maxLines: 10,
                    ),
                    FormTextField(
                      controller: _locationController, 
                      title: "Location"
                    ),

                    Text("Date: ${_selectedDate != null ? DateFormat("dd-mm-yyyy").format(_selectedDate!) : 'Not selected'}"),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                    const SizedBox(height: 10),
                    Text('Time: ${_selectedTime != null ? _selectedTime!.format(context) : 'Not selected'}'),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null && pickedTime != _selectedTime) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      child: const Text('Select Time'),
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