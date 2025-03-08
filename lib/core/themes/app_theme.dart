import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primary,
  primaryColorLight: AppColors.primary,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: AppColors.whiteColor,
  brightness: Brightness.light,
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary.withValues(alpha: 0.8),
      foregroundColor: AppColors.whiteColor,
      shadowColor: AppColors.secondary,
      elevation: 1.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.fifthColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 1.5,
    backgroundColor: AppColors.secondary.withValues(alpha: 0.6),
    foregroundColor: AppColors.primary,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.whiteColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: AppColors.fifthColor),
    labelStyle: const TextStyle(color: AppColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.thirdMintGreen),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.thirdMintGreen),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.thirdMintGreen),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.blackColor,
    foregroundColor: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: AppColors.blackColor,
  brightness: Brightness.dark,
  useMaterial3: true,
);
