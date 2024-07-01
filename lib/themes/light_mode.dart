import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: "Urbanist",
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    onSurfaceVariant: Color(0xFF000000),

    primary: Color(0xFF4B39EF),
    onPrimaryFixedVariant: Color(0xFF6849EF),

    secondary: Color(0xFF8a72f1),
    onSecondaryFixedVariant: Color(0xFFA095FF),

    tertiary: Color(0xFFEBEBEC),
    onTertiary: Color(0xFF757574),
    onTertiaryFixedVariant: Color(0xFF757575),
    
    inverseSurface: Color(0xFF6849EF),
    
    
  )
);
