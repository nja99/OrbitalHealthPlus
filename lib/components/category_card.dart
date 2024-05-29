import "package:flutter/material.dart";
import "package:healthsphere/assets/model/category.dart";

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 0.05,
            ),
          ],
        ),
      ),
    );
  }
}