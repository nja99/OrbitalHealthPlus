import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final double height;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surface),
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.tertiary),
      child: Image.asset(
        imagePath,
        height: height
      ),
    );
  }
}