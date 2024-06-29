import 'package:healthsphere/screens/appointment_screen.dart';
import 'package:healthsphere/screens/home_screen.dart';
import 'package:healthsphere/screens/medication_screen.dart';
import 'package:healthsphere/utils/page_data.dart';


final List<PageData> pages = [
  PageData(page: const HomeScreen(), title: "Home", showSearchBar: true),
  // PageData(page: const HomeScreen(), title: "Health Monitor"),
  PageData(page: const MedicationScreen(), title: "Medications"),
  PageData(page: const AppointmentScreen(), title: "Appointments"),
  PageData(page: const HomeScreen(), title: "Home"),
];
