import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {

  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? prefixIcon;
  final ValueChanged? onChanged;

  const FormTextField({
    super.key,
    required this.controller,
    required this.title,
    this.validator,
    this.maxLines,
    this.prefixIcon,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.w600,
            )
          ),

          // Input Box
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(25)
            ),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14)
              ),
              maxLines: maxLines,
              controller: controller,
              validator: validator,
              onChanged: onChanged,
            )
          )
        ]
      )
    );
  }

}