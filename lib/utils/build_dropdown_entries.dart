import 'package:flutter/material.dart';

List<DropdownMenuEntry<String>> buildDropdownEntries(List<String> items) {
  return items.map((String item) {
    return DropdownMenuEntry<String>(
      value: item,
      label: item,
    );
  }).toList();
}
