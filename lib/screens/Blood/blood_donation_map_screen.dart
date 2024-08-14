import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthsphere/assets/model/blood_donation_drives.dart';
import 'package:permission_handler/permission_handler.dart';

class BloodDonationMapScreen extends StatefulWidget {
  const BloodDonationMapScreen({Key? key}) : super(key: key);

  @override
  State<BloodDonationMapScreen> createState() => _BloodDonationMapScreenState();
}

class _BloodDonationMapScreenState extends State<BloodDonationMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng initialLocation = const LatLng(1.3521, 103.8198); // Singapore's coordinates
  double _currentZoom = 11.0;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _onMarkerTapped(BloodDonationDrive drive) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(drive.location, _currentZoom + 5));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Text(drive.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(drive.address),
                  SizedBox(height: 8),
                  Text(drive.openingHours),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('View Details'),
                    onPressed: () {
                      // Implement view details functionality
                      print('View details for ${drive.name}');
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Select This Location'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, drive);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _requestPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Blood Donation Location'),
        backgroundColor: Colors.red,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: _currentZoom,
        ),
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: bloodDonationDrives.map((drive) {
          return Marker(
            markerId: MarkerId(drive.name),
            position: drive.location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () => _onMarkerTapped(drive),
          );
        }).toSet(),
        onCameraMove: (CameraPosition position) {
          _currentZoom = position.zoom;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: () {
          // Implement logic to go to user's current location
        },
      ),
    );
  }
}