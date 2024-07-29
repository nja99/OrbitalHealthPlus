import 'package:flutter/material.dart';
import "package:healthsphere/assets/model/category.dart";

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  
  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 80,
        width: 50,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Image.asset(
                category.thumbnail,
                height: 45,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }
}