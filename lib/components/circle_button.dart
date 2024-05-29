import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const CircleButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: Theme.of(context).colorScheme.primary
      ),
      child: Icon(
        icon,
        size: 30,
        color:Theme.of(context).colorScheme.surface,
      ),
    );
  }
}