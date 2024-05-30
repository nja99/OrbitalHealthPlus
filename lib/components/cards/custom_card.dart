import "package:flutter/material.dart";

class CustomCard extends StatelessWidget {

  final Widget child;

  const CustomCard({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFC8B4FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: child
      );
  }
}