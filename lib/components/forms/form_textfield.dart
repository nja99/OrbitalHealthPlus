import "package:flutter/material.dart";

class FormTextField extends StatelessWidget {

  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final int? maxLines;


  const FormTextField({
    super.key,
    required this.controller,
    required this.title,
    this.validator,
    this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: maxLines,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Same as enabledBorder
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: validator,
          )
        ]
      )
    );
  }

}