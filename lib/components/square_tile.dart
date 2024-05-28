import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final double height;
  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.height,
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.surface),
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Image.asset(
          imagePath,
          height: height
        ),
      ),
    );
  }
}