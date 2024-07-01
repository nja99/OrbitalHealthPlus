import 'package:flutter/material.dart';

class HomeDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const HomeDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.secondary,      
        ),
        onTap: onTap,
      ),
    );
  }
}