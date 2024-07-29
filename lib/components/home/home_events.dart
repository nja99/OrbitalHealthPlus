import 'package:flutter/material.dart';
import "package:healthsphere/components/cards/category_card.dart";
import 'package:healthsphere/assets/model/category.dart';
import 'package:healthsphere/pages/drugdatabase_page.dart';
import 'package:healthsphere/pages/settings_page.dart';
import 'package:healthsphere/screens/appointment_screen.dart';
import 'package:healthsphere/screens/blooddonation.dart';
import 'package:healthsphere/screens/familyhub_screen.dart';
import 'package:healthsphere/screens/medication_screen.dart';

class HomeEvents extends StatefulWidget {
final Function(int) onCategorySelected;
  final int currentIndex;

  const HomeEvents({Key? key, required this.onCategorySelected, required this.currentIndex}) : super(key: key);

  @override
  State<HomeEvents> createState() => _HomeEventsState();
}
class _HomeEventsState extends State<HomeEvents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explore Categories',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600, 
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: categoryList.length,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24
          ),
          itemBuilder: (context, index) {
            return CategoryCard(
            category: categoryList[index],
                onTap: () {
                switch (categoryList[index].name) {
                    case 'Family':
                      widget.onCategorySelected(3);
                    break;
                  case 'Medication':
                      widget.onCategorySelected(1);
                    break;
                  case 'Appointment':
                      widget.onCategorySelected(2);
                    break;
                  case 'Database':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DrugDatabasePage()),
                    );
                  return; // Add this to exit the function after navigation
                  case 'Blood Donation': 
                  // Make sure this matches exactly with your category name
                    Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context) => BloodDonationScreen()),
                    );
                    return; // Add this to exit the function after navigation
                  case 'Settings':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  default:
                    widget.onCategorySelected(0);
                }
              }
            );
          },
        ),
      ],
    );
  }
}