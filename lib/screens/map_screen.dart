import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthsphere/assets/model/clinic.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? markerbitmap;

  LatLng initialLocation = const LatLng(1.3521, 103.8198); // Singapore's coordinates

  Future<void> _requestPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addCustomIcon();
    });
  }

  void addCustomIcon() async {
      final customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), // Specify a custom size here
        'assets/images/marker_small.png', // Use the resized image
      );
      setState(() {
        markerbitmap = customIcon;
      });
  }

  void _onMarkerTapped(Clinic clinic) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(clinic.name),
            content: Text(clinic.address),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true, // Enable showing user's location
            myLocationButtonEnabled: true, // Enable the location button
            markers: clinics.where((clinic) {
              return clinic.name.isNotEmpty && clinic.location != null;
            }).map((clinic) {
              return Marker(
                markerId: MarkerId(clinic.name),
                position: clinic.location,
                icon: markerbitmap ?? BitmapDescriptor.defaultMarker,
                onTap: () => _onMarkerTapped(clinic),
              );
            }).toSet(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter location',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      child: const Text('Confirm Location'),
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
}
