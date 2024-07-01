import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {

  final String buttonText;
  final IconData? iconData;
  final Function()? onPressed;

  const UserButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.iconData
    });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 5,

        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(iconData != null)
                Icon(iconData),
              const SizedBox(width: 8),
              Text(
                buttonText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),)
            ],
          )
        ),
      ),
    );
  }
}