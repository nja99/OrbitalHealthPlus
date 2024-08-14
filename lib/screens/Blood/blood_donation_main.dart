import 'package:flutter/material.dart';
import 'package:healthsphere/screens/Blood/blood_appt.dart';

class BloodDonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Appointment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(context),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please select your donation type below.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    _buildDonationTypeCard(
                      icon: Icons.opacity,
                      title: 'Blood Donation',
                      color: Colors.red,
                      onPressed: () => _navigateToAppointmentScreen(context),
                    ),
                    SizedBox(height: 20),
                    _buildDonationTypeCard(
                      icon: Icons.water_drop,
                      title: 'Apheresis Donation',
                      color: Colors.teal,
                      onPressed: () => _navigateToAppointmentScreen(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              _buildProgressStep('Appointment', false),
              _buildProgressStep('Confirmation', false),
            ],
          ),
          SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 2,
                color: Colors.grey[300],
              ),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width / 4,
                color: Colors.red,
              ),
            ],
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

  Widget _buildDonationTypeCard({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 60, color: color),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Get Appointment', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: () {
              print('Info button tapped for $title');
            },
            child: Icon(Icons.help_outline, color: Colors.grey[400], size: 24),
          ),
        ),
      ],
    ),
  );
}

  void _navigateToAppointmentScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BloodDonationAppointmentScreen()),
    );
  }
}