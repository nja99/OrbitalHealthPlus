import 'package:flutter/material.dart';
import "package:healthsphere/components/cards/category_card.dart";
import 'package:healthsphere/assets/model/category.dart';

class HomeEvents extends StatefulWidget {
final Function(int) onCategorySelected;
  final int currentIndex;

  const HomeEvents({
    super.key, 
    required this.onCategorySelected, 
    required this.currentIndex
  });
  
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
                case 'Medication':
                  newIndex = 1;
                  break;
                case 'Appointment':
                  newIndex = 2;
                  break;
                case 'Family':
                    newIndex = 3;
                    break;
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
