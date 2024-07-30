import 'package:flutter/material.dart';

class BloodDonationAppointmentScreen extends StatefulWidget {
  @override
  _BloodDonationAppointmentScreenState createState() => _BloodDonationAppointmentScreenState();
}

class _BloodDonationAppointmentScreenState extends State<BloodDonationAppointmentScreen> {
  DateTime? selectedDate;
  String? selectedCity;
  String? selectedFacility;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Appointment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDonationTypeHeader(),
                    SizedBox(height: 24),
                    _buildInputField('Appointment Date', selectedDate?.toString().split(' ')[0] ?? '', Icons.calendar_today, _selectDate),
                    SizedBox(height: 16),
                    _buildInputField('City', selectedCity ?? '', Icons.arrow_drop_down, _selectCity),
                    SizedBox(height: 16),
                    _buildInputField('Blood Donation Facility', selectedFacility ?? '', Icons.arrow_drop_down, _selectFacility),
                    SizedBox(height: 16),
                    _buildInputField('Appointment Time', selectedTime?.format(context) ?? '', Icons.access_time, _selectTime),
                    SizedBox(height: 24),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressDot('Donation Type', true),
              _buildProgressDot('Appointment', true),
              _buildProgressDot('Confirmation', false),
            ],
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildProgressLine(true)),
                Expanded(child: _buildProgressLine(false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDot(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.red : Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? Colors.red : Colors.grey,
    );
  }

  Widget _buildDonationTypeHeader() {
    return Row(
      children: [
        Icon(Icons.opacity, color: Colors.red, size: 24),
        SizedBox(width: 8),
        Text(
          'Blood Donation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String value, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.isEmpty ? 'Select $label' : value,
                  style: TextStyle(
                    color: value.isEmpty ? Colors.grey[400] : Colors.black,
                    fontSize: 16,
                  ),
                ),
                Icon(icon, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      child: Text('Continue', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: Size(double.infinity, 48),
      ),
      onPressed: _allFieldsFilled() ? _continue : null,
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectCity() {
    // Implement city selection logic
  }

  void _selectFacility() {
    // Implement facility selection logic
  }

  void _selectTime() async {
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

  bool _allFieldsFilled() {
    return selectedDate != null &&
        selectedCity != null &&
        selectedFacility != null &&
        selectedTime != null;
  }

  void _continue() {
    // Implement continue logic
  }
}