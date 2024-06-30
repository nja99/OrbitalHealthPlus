import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  
  const DateTimeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            )
          ),

          // Selector
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(25.0),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25.0)
              ),
              child: Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 12.0),
                  Text(value)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}