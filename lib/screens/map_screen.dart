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
      const ImageConfiguration(size: Size(128, 128)), // Specify a custom size here
      'lib/assets/images/marker_big.png', // Use the resized image
    );
    setState(() {
      markerbitmap = customIcon;
    });
  }

  void _onMarkerTapped(Clinic clinic) {
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
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 8), // Margin for spacing to show part of the map
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(), // Leave empty for spacing
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context); // Pop the navigation here
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        ListTile(
                          leading: Image.asset(clinic.imagePath, width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(clinic.name),
                          subtitle: Text(clinic.address),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Open • Closes at ${clinic.openingHours}"),
                        ),
                        ElevatedButton(
                          onPressed: () { },
                          child: const Text('View details'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                            // Handle order action
                            },
                            style: ElevatedButton.styleFrom(foregroundColor: Colors.yellow),
                            child: const Text('Choose Location', style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
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

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    var location = await _getUserLocation();
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  Future<LatLng> _getUserLocation() async {
    // This is a placeholder for getting the user's current location.
    // Implement your location fetching logic here.
    return initialLocation; // Replace this with actual user location
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              myLocationButtonEnabled: false, // Disable the default location button
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
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text('Clinics'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    iconSize: 34.0, // Increase the size here
                    onPressed: () {
                      // Handle search icon press
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 32,
              left: 16,
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




