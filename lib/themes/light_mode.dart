import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: "Urbanist",
  scaffoldBackgroundColor: const Color(0xFFF8F4F3),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: const Color(0xFF8a72f1),
    onPrimaryFixedVariant: const Color(0xFF6849ef),

    secondary: const Color(0xFF4B39EF),
    onSecondaryFixedVariant: const Color.fromARGB(255, 160, 149, 255),

    tertiary: Colors.grey.shade300,
    onTertiaryFixedVariant: Colors.grey.shade600,
    
    inverseSurface: const Color.fromARGB(255, 0, 0, 0),
    
  )
);
