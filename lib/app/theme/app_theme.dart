import 'package:flutter/material.dart';

extension AppTheme on ThemeData {
  ColorScheme get navyIndigoScheme => ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF1B2A4A),
    onPrimary: Colors.white,
    secondary: const Color(0xFF6C5CE7),
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: const Color(0xFF1A202C),
    error: const Color(0xFFEF4444),
    onError: Colors.white,
  );
}

class AppConstants {
  static const double loginCardMaxWidth = 440.0;

  static const double mobileHorizontalPadding = 24.0;

  static const double borderRadius = 12.0;

  static const double fieldSpacing = 16.0;

  static const List<String> demoEmails = [
    'admin@test.com',
    'senior@test.com',
    'staff@test.com',
  ];
}
