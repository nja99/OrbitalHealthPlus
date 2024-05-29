import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    fontFamily: "Urbanist",
    colorScheme: ColorScheme.light(
      // Surface + Surface Text
      surface: Colors.white,
      onSurface: Colors.grey.shade700,

      // Widgets
      primary: Colors.white,

      // Buttons
      secondary: const Color(0xFF4B39EF),
      onSecondary: Colors.white,

      // Form Field
      tertiary: Colors.white,
      onTertiary: Colors.grey.shade500,

      inversePrimary: Colors.grey.shade500,
    )
);
