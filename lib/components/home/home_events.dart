import 'package:flutter/material.dart';
import "package:healthsphere/components/cards/category_card.dart";
import 'package:healthsphere/assets/model/category.dart';
import 'package:healthsphere/pages/settings_page.dart';
import 'package:healthsphere/screens/appointment_screen.dart';
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
              int newIndex;
              switch (categoryList[index].name) {
                case 'Family':
                  newIndex = 3;
                  break;
                case 'Medication':
                  newIndex = 1;
                  break;
                case 'Appointment':
                  newIndex = 2;
                  break;
                case 'Particulars':
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                newIndex = widget.currentIndex;
                default:
                  newIndex = 0;
              }
              widget.onCategorySelected(newIndex);
            },
            );
          },
        ),
      ],
    );
  }
}
