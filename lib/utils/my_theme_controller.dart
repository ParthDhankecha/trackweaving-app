import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors
          .mainColor, // Used for primary elements (e.g., button colors, selected state, DatePicker header)
      onPrimary: Colors
          .white, // Used for text/icons on the primary color background (e.g., text inside buttons)
      secondary: AppColors
          .mainColor, // Optional: For secondary accents, often set to primary for simplicity
    ),

    // 2. Optional: Set primary color directly (for backward compatibility, but ColorScheme is preferred)
    primaryColor: AppColors.mainColor,

    // 3. Optional: Customize specific widget themes (e.g., TextButton style for dialogs)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors
            .mainColor, // Sets the color for OK/CANCEL text in DatePicker/Dialogs
      ),
    ),

    // 5. Optional: Customize Floating Action Button (FAB)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainColor,
    ),

    // Use Material 3
    useMaterial3: true,

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      textStyle: TextStyle(color: Colors.black),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      dayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white; // white text when selected
        }
        return AppColors.mainColor; // default text color
      }),

      // Day background color (changes when selected)
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.mainColor; // red background for selected day
        }
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered)) {
          return AppColors.mainColor;
        }

        if (states.contains(WidgetState.any)) {
          return AppColors.mainColor;
        }

        return Colors.transparent; // default
      }),

      todayForegroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
      todayBackgroundColor: WidgetStatePropertyAll(AppColors.mainColor),
      // Outline border for today
      dayOverlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.selected)) {
          return AppColors.mainColor; // light tint for today
        }
        return null;
      }),

      // other properties as needed
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: AppColors.appBg,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBg,
      surfaceTintColor: AppColors.appBg,
    ),
    cardColor: Colors.white,

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        surfaceTintColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple[5]),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    log('them mode changed : $_themeMode');
    Get.changeTheme(_themeMode == ThemeMode.light ? lightTheme : darkTheme);
    refresh();
  }
}
