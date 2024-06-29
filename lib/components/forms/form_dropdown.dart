import 'package:flutter/material.dart';
import 'package:healthsphere/utils/build_dropdown_entries.dart';

class FormDropdown extends StatelessWidget {
  
  final String title;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onSelected;

  const FormDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.onSelected,
    required this.items,
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
              fontWeight: FontWeight.bold
            ),
          ),

          // Dropdown
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25)
            ),
  
            child: DropdownMenu<String> (
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              initialSelection: value,
              expandedInsets: const EdgeInsets.all(0),
              onSelected: onSelected,
              dropdownMenuEntries: buildDropdownEntries(items),
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                filled: false
              ),
            ),
          )
        ],
      ),
    );
  }
}