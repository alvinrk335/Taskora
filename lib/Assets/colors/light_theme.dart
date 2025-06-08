import 'package:flutter/material.dart';
import 'package:taskora/Assets/colors/app_colors.dart';

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
      surface: AppColors.text,
      onPrimary: AppColors.text,
      onSecondary: AppColors.text,
      onBackground: AppColors.text,
      onSurface: AppColors.text,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: AppColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
      titleMedium: TextStyle(color: AppColors.text), // Untuk label input
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white, // Lebih kontras di background terang
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.background),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.black54),
      labelStyle: TextStyle(color: AppColors.primary),
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      iconColor: AppColors.primary,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: AppColors.background, // Warna background dialog
      titleTextStyle: TextStyle(
        color: AppColors.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(color: AppColors.text, fontSize: 16),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.background, // Warna background drawer
      scrimColor: Colors.black.withOpacity(
        0.5,
      ), // Warna overlay saat drawer kebuka
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.background,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      surfaceTintColor: AppColors.primary,
      dayForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return AppColors.text;
      }),
      dayBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.accent;
        return Colors.transparent;
      }),
      yearForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return AppColors.text;
      }),
      yearBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return AppColors.accent;
        return Colors.transparent;
      }),
      todayForegroundColor: MaterialStateProperty.all(AppColors.primary),
      todayBackgroundColor: MaterialStateProperty.all(
        AppColors.primary.withOpacity(0.2),
      ),
    ),
  );
}
