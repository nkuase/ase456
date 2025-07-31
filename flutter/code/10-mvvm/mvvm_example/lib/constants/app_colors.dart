// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Basic colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFFFF4081);
  
  // Grayscale
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
  static const Color background = Color(0xFFF5F5F5);
  
  // Icon colors
  static const Color iconPhone = Color(0xFF4CAF50);
  static const Color iconLocation = Color(0xFFF44336);
  static const Color iconBirthday = Color(0xFFE91E63);
  static const Color iconSettings = Color(0xFF607D8B);
  
  // MaterialColor (used in ThemeData)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF2196F3,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  
  // Card colors
  static const Color cardBackground = Colors.white;
  static const Color cardShadow = Color(0x1F000000);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}