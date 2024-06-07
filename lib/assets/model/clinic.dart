import 'package:google_maps_flutter/google_maps_flutter.dart';

class Clinic {
  final String name;
  final String address;
  final LatLng location;
  final String details;
  final String openingHours;
  final String imagePath;

  Clinic({
    required this.name,
    required this.address,
    required this.location,
    required this.details,
    required this.openingHours,
    required this.imagePath,
  });
}

final List<Clinic> clinics = [
  Clinic(
    name: "Choa Chu Kang Polyclinic",
    address: "2 Teck Whye Cres, Singapore 688846",
    location: const LatLng(1.3815393615246123, 103.7514617146475),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "Pioneer Polyclinic",
    address: "26 Jurong West Street 61, Singapore 648201",
    location: const LatLng(1.3386304108326255, 103.6990154162251),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "NHGP Woodlands Polyclinic",
    address: "10 Woodlands Street 31, Singapore 738579",
    location: const LatLng(1.4308221745209981, 103.77507276669321),
    details: "hello",
    openingHours:"Weekday: 8am - 530pm \n Saturday 8am - 1:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "Jurong Polyclinic",
    address: "190 Jurong East Ave 1, Singapore 609788",
    location: const LatLng(1.3498350034346824, 103.73061363560201),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "Bukit Batok Polyclinic ",
    address: "50 Bukit Batok West Ave 3, Singapore 659164",
    location: const LatLng(1.3520085178396501, 103.74792070498206),
    details: "hello",
    openingHours:"Weekday: 8am - 4pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "BP Polyclinic",
    address: "50 Woodlands Rd, #03-02, Singapore 677726",
    location: const LatLng(1.383100265220688, 103.75983135510569),
    details: "hello",
    openingHours:"Weekday:8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "NHGP Sembawang Polyclinic",
    address: "21 Canberra Link, Singapore 756973",
    location: const LatLng(1.4497723623024295, 103.82333278786048),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "NHGP Yishun Polyclinic",
    address: "1.4329763212578661, 103.83921146522194",
    location: const LatLng(1.4329763212578661, 103.83921146522194),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "NHGP Toa Payoh Polyclinic",
    address: "2003 Lor 8 Toa Payoh, Singapore 319260",
    location: const LatLng(1.3388583367984452, 103.85949969422413),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "NHGP Ang Mo Kio Polyclinic",
    address: "21 Ang Mo Kio Central 2, Singapore 569666",
    location: const LatLng(1.377299682750295, 103.8447368157691),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "Queenstown Polyclinic",
    address: "580 Stirling Rd, Singapore 148958",
    location: const LatLng(1.3012775301555601, 103.80131523599005),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12:30pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),
  Clinic(
    name: "Clementi Polyclinic",
    address: "451 Clementi Ave 3, #02-307, Singapore 120451",
    location: const LatLng(1.31316831459032, 103.76580342666671),
    details: "hello",
    openingHours:"Weekday: 8am - 430pm \n Saturday 8am - 12pm only ",
    imagePath: "lib/assets/images/marker.png",
  ),

];