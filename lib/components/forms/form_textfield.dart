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
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.bold,
            )
          ),

          // Input Box
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)
            ),
            child: TextFormField(
              decoration: const InputDecoration.collapsed(hintText: ""),
              maxLines: maxLines,
              controller: controller,
              validator: validator,
            )
          )
        ]
      )
    );
  }

}