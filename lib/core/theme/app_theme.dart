import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'EXPOARABIC',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.darkText,
        onError: AppColors.white,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(
          fontFamily: 'EXPOARABIC',
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        displayMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        displaySmall: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkText,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.darkTextSecondary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: 'EXPOARABIC',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      cardTheme: CardThemeData(color: AppColors.darkSurface, elevation: 2),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: TextStyle(
          fontFamily: 'EXPOARABIC',
          color: AppColors.darkText,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'EXPOARABIC',

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.lightText,
        onError: AppColors.white,
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'EXPOARABIC',
          color: AppColors.white, // White text on dark surface
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
        ),
        displayMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
        ),
        displaySmall: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        titleLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        titleMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.lightText,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.lightText,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.lightText,
        ),
        bodySmall: TextStyle(
          fontFamily: 'EXPOARABIC',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.lightText,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: 'EXPOARABIC',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        // Force white text on dark cards
        surfaceTintColor: Colors.transparent,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle: TextStyle(
          fontFamily: 'EXPOARABIC',
          color: AppColors.white,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
