import 'package:flutter/material.dart';
import 'package:healthsphere/utils/build_dropdown_entries.dart';

class UserDropdown extends StatelessWidget {
  
  final String label;
  final List<String> items;
  final ValueChanged<String?> onSelected;

  const UserDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: DropdownMenu<String> (
        label: Text(
          label, 
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiaryFixedVariant, 
            fontSize: 16)
          ),
        expandedInsets: const EdgeInsets.all(0),
        onSelected: onSelected,
        dropdownMenuEntries: buildDropdownEntries(items),
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder()
        ),
      ),
    );
  }
}