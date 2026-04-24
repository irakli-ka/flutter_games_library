import 'package:flutter/material.dart';

class AppColors {
  static const Color myBackground = Color(0xFF333333);
  static const Color myDarkerBackground = Color(0xFF1A1A1A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFD1CCD3);

  static const Color iconColor = Color(0xFF78737D);

  static const Color ratingHigh = Color(0xFF4CAF50);
  static const Color ratingMedium = Color(0xFFFF9800);
  static const Color ratingLow = Color(0xFFF44336);
  static const Color ratingNa = Color(0x00FFFFFF);

  static const Color linkColor = Color(0xFF4488A6);
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.myBackground,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.myBackground,
      primary: AppColors.iconColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.iconColor,
    ),
  );
}