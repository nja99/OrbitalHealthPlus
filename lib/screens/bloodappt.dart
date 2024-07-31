import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/date_time_widget.dart';
import 'package:healthsphere/screens/blood_donation_map_screen.dart';
import 'package:healthsphere/assets/model/blood_donation_drives.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';
import 'package:healthsphere/services/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BloodDonationAppointmentScreen extends StatefulWidget {
  @override
  _BloodDonationAppointmentScreenState createState() => _BloodDonationAppointmentScreenState();
}

class _BloodDonationAppointmentScreenState extends State<BloodDonationAppointmentScreen> {
  final UserProfileService userProfileService = getIt<UserProfileService>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  BloodDonationDrive? selectedLocation;
  bool useCurrentProfile = false;
  Map<String, dynamic>? userProfileData;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final user = authProvider.user;
  if (user != null) {
    return await userProfileService.getUserProfile(user);
  }
  return null;
}

Widget _buildProgressIndicator(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProgressStep('Donation Type', true),
            _buildProgressStep('Appointment', true),
            _buildProgressStep('Confirmation', false),
          ],
        ),
        SizedBox(height: 4),
        Container(
          height: 2,
          color: Colors.grey[300],
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildProgressStep(String label, bool isActive) {
  return Column(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.red : Colors.grey[300],
        ),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donation Appointment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          _buildProgressIndicator(context),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blood Donation',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                DateTimeWidget(
                  title: 'Location',
                  value: selectedLocation?.name ?? 'Select Location',
                  icon: Icons.location_on,
                  onTap: _selectLocation,
                ),
                DateTimeWidget(
                  title: 'Date',
                  value: selectedDate != null
                      ? DateFormat("dd-MMM-yyyy").format(selectedDate!)
                      : 'Select Date',
                  icon: Icons.calendar_today,
                  onTap: _selectDate,
                ),
                DateTimeWidget(
                  title: 'Time',
                  value: selectedTime != null
                      ? selectedTime!.format(context)
                      : 'Select Time',
                  icon: Icons.access_time,
                  onTap: _selectTime,
                ),
                SizedBox(height: 20),
                Text(
                  'Use current account profile details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SwitchListTile(
                  title: Text('Use current profile'),
                  value: useCurrentProfile,
                  onChanged: (bool value) async {
                    setState(() {
                      useCurrentProfile = value;
                    });
                    if (value) {
                      userProfileData = await _fetchUserProfile();
                      setState(() {});
                    }
                  },
                ),
                if (useCurrentProfile && userProfileData != null)
                  _buildUserProfileDetails(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Continue', style: TextStyle(color: Colors.white)),
                  onPressed: _isFormValid() && useCurrentProfile ? _continuePressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: '${userProfileData!['firstName']} ${userProfileData!['lastName']}',
          decoration: InputDecoration(labelText: 'Name'),
          readOnly: true,
        ),
        TextFormField(
          initialValue: userProfileData!['dateOfBirth'] != null
              ? DateFormat('dd-MMM-yyyy').format((userProfileData!['dateOfBirth'] as Timestamp).toDate())
              : 'N/A',
          decoration: InputDecoration(labelText: 'Date of Birth'),
          readOnly: true,
        ),
        TextFormField(
          initialValue: '${userProfileData!['height']} cm',
          decoration: InputDecoration(labelText: 'Height'),
          readOnly: true,
        ),
        TextFormField(
          initialValue: '${userProfileData!['weight']} kg',
          decoration: InputDecoration(labelText: 'Weight'),
          readOnly: true,
        ),
        TextFormField(
          initialValue: userProfileData!['sex'] ?? 'N/A',
          decoration: InputDecoration(labelText: 'Sex'),
          readOnly: true,
        ),
        TextFormField(
          initialValue: userProfileData!['bloodType'] ?? 'N/A',
          decoration: InputDecoration(labelText: 'Blood Type'),
          readOnly: true,
        ),
      ],
    );
  }


  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BloodDonationMapScreen()),
    );
    if (result != null && result is BloodDonationDrive) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  bool _isFormValid() {
    return selectedDate != null && selectedTime != null && selectedLocation != null;
  }

  void _continuePressed() {
    // Implement the logic for continuing to the next step
    print('Appointment details:');
    print('Date: ${selectedDate.toString()}');
    print('Time: ${selectedTime!.format(context)}');
    print('Location: ${selectedLocation!.name}');
    print('Use current profile: $useCurrentProfile');
    if (useCurrentProfile) {
      print('User Profile: $userProfileData');
    }
  }
}