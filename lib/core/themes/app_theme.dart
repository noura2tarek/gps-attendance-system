import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: AppColors.whiteColor,

  brightness: Brightness.light,
  useMaterial3: true,
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
