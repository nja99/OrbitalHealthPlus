// lib/screens/blood_donation_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthsphere/assets/model/clinic.dart';
import 'package:healthsphere/components/expanded_container.dart';
import 'package:healthsphere/screens/map_screen.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';

class BloodDonationScreen extends StatefulWidget {
  const BloodDonationScreen({Key? key}) : super(key: key);

  @override
  _BloodDonationScreenState createState() => _BloodDonationScreenState();
}

class _BloodDonationScreenState extends State<BloodDonationScreen> {
  
  final UserProfileService userProfileService = getIt<UserProfileService>();
  final TextEditingController _locationController = TextEditingController();
  Clinic? selectedClinic;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      appBar: AppBar(
        title: const Text('Blood Donation'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ExpandedContainer(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Select Blood Donation Center',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Select Location',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () => _navigateToMap(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _navigateToMap(context),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Date and Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(selectedDate == null
                            ? 'Select Date'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text(selectedTime == null
                            ? 'Select Time'
                            : selectedTime!.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _confirmDonation : null,
                    child: const Text('Confirm Donation'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (result != null && result is Clinic) {
      setState(() {
        selectedClinic = result;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  bool _isFormValid() {
    return selectedClinic != null && selectedDate != null && selectedTime != null;
  }

  void _confirmDonation() {
    // Here you would typically send the donation data to your backend
    // For now, we'll just show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Donation Confirmed'),
          content: Text(
            'Your blood donation appointment has been scheduled for ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedTime!.format(context)} at ${selectedClinic!.name}.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to home screen
              },
            ),
          ],
        );
      },
    );
  }
}