import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class Themes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.appColorBlue,
    backgroundColor: AppColors.whiteColor,
    // scaffoldBackgroundColor: AppColors.appColorBlue,
    iconTheme: const IconThemeData(color: AppColors.whiteColor),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appColorBlue,
      foregroundColor: AppColors.blackColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.whiteColor,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      actionsIconTheme: IconThemeData(
        color: AppColors.whiteColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.appColorBlue,
    ),
    cardColor: AppColors.whiteColor,
  );
}
