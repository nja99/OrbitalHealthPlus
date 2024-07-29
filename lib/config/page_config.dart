import 'package:healthsphere/screens/appointment_screen.dart';
import 'package:healthsphere/screens/blooddonation.dart';
import 'package:healthsphere/screens/familyhub_screen.dart';
import 'package:healthsphere/screens/home_screen.dart';
import 'package:healthsphere/screens/medication_screen.dart';
import 'package:healthsphere/utils/page_data.dart';


final List<PageData> pages = [
  PageData(
    pageBuilder: (onCategorySelected, currentIndex) => HomeScreen(
      onCategorySelected: onCategorySelected,
      currentIndex: currentIndex,
    ),
    title: "Home",
    showSearchBar: true
  ),
  PageData(
    pageBuilder: (_, __) => const MedicationScreen(),
    title: "Medications"
  ),
  PageData(
    pageBuilder: (_, __) => const AppointmentScreen(),
    title: "Appointments"
  ),
  PageData(
    pageBuilder: (_, __) => const FamilyScreen(),
    title: "FamilyHub"
  ),
  PageData(
    pageBuilder: (_, __) => BloodDonationScreen(),
    title: "Blood Donation"
  ),
];