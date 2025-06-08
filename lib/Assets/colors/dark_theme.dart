import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF4F5BD5), // Indigo
      secondary: const Color(0xFF5AC8FA), // Soft Blue
      background: const Color(0xFF181A20), // Deep blue-gray
      surface: const Color(0xFF23243A), // Card/dialog
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFFF7F8FA),
      onSurface: Color(0xFFF7F8FA),
      error: const Color(0xFFFF3B30),
    ),
    scaffoldBackgroundColor: const Color(0xFF181A20),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF23243A),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: const Color(0xFF23243A),
    cardTheme: CardTheme(
      color: const Color(0xFF23243A),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5AC8FA),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: const Color(0xFF5AC8FA).withOpacity(0.15),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFF4F5BD5),
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFFF7F8FA), // Default text: white
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(color: Color(0xFFF7F8FA), fontSize: 14),
      titleMedium: TextStyle(
        color: Color(0xFFF7F8FA), // Use white for titles
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFFF7F8FA), // Use white for headlines
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF5AC8FA), // Use secondary only for labels/badges
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF23243A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF35364D)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF23243A)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF5AC8FA), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
      labelStyle: const TextStyle(
        color: Color(0xFF5AC8FA),
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFF5AC8FA),
        fontWeight: FontWeight.w600,
      ),
      iconColor: const Color(0xFF5AC8FA),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF23243A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: Color(0xFF5AC8FA),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFFF7F8FA), fontSize: 16),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: const Color(0xFF23243A),
      scrimColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xFF23243A),
      headerBackgroundColor: const Color(0xFF4F5BD5),
      headerForegroundColor:
          Colors.white, // Ensures year and chevrons are white
      surfaceTintColor: const Color(0xFF4F5BD5),
      dayForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return const Color(0xFFF7F8FA);
      }),
      dayBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF5AC8FA);
        }
        return Colors.transparent;
      }),
      yearForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return const Color(0xFFF7F8FA);
      }),
      yearBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF5AC8FA);
        }
        return Colors.transparent;
      }),
      todayForegroundColor: MaterialStateProperty.all(const Color(0xFF4F5BD5)),
      todayBackgroundColor: MaterialStateProperty.all(
        const Color(0xFF4F5BD5).withOpacity(0.13),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
