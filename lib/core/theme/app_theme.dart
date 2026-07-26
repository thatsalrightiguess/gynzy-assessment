import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        background: Colors.white,
      ),
      // Set a clean and professional font family if needed, default is fine for now
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
        bodyLarge: TextStyle(fontSize: 18, color: AppColors.text),
      ),
    );
  }
}
