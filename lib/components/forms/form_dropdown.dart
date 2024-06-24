import "package:flutter/material.dart";

class FormDropdown extends StatelessWidget {
  
  final String title;
  final String? value;
  final ValueChanged<String?> onSelected;
  final List<String> items;

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
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)
            ),
  
            child: DropdownMenu<String> (
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              initialSelection: value,
              expandedInsets: const EdgeInsets.all(0),
              onSelected: onSelected,
              dropdownMenuEntries: _buildDropdownEntries(items),
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

  List<DropdownMenuEntry<String>> _buildDropdownEntries(List<String> items) {
    return items.map((String item){ 
      return DropdownMenuEntry<String> (
        value: item,
        label: item,
      );
    }).toList();
  }
}