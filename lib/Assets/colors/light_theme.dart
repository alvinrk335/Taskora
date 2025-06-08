import 'package:flutter/material.dart';
import 'package:taskora/Assets/colors/box_decoration_theme.dart';

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1976D2), // Previous primary blue
      secondary: const Color(0xFF5AC8FA), // Soft Blue (suggested)
      background: const Color(0xFFF7F8FA),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: const Color(0xFF222B45),
      onBackground: const Color(0xFF222B45),
      onSurface: const Color(0xFF222B45),
      error: const Color(0xFFFF3B30),
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: Colors.white,
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFF222B45), // Default text: black
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(color: Color(0xFF222B45), fontSize: 14),
      titleMedium: TextStyle(
        color: Color(0xFF222B45), // Use black for titles
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF222B45), // Use black for headlines
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF5AC8FA), // Use secondary only for labels/badges
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(
          0xFF5AC8FA,
        ), // Use secondary color for buttons
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: const Color(0xFF5AC8FA).withOpacity(0.15),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE4E9F2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF7F8FA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
      labelStyle: const TextStyle(
        color: Color(0xFF1976D2),
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFF1976D2),
        fontWeight: FontWeight.w600,
      ),
      iconColor: const Color(0xFF1976D2),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: Color(0xFF1976D2),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFF222B45), fontSize: 16),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
      scrimColor: Colors.black.withOpacity(0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: const Color(0xFF1976D2),
      headerForegroundColor: Colors.white,
      surfaceTintColor: const Color(0xFF1976D2),
      dayForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return const Color(0xFF222B45);
      }),
      dayBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return const Color(0xFF5AC8FA);
        return Colors.transparent;
      }),
      yearForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return Colors.white;
        return const Color(0xFF222B45);
      }),
      yearBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return const Color(0xFF5AC8FA);
        return Colors.transparent;
      }),
      todayForegroundColor: MaterialStateProperty.all(const Color(0xFF1976D2)),
      todayBackgroundColor: MaterialStateProperty.all(
        const Color(0xFF1976D2).withOpacity(0.13),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      TaskoraBoxDecorationTheme(
        card: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1976D2).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        input: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.12)),
        ),
        dialog: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1976D2).withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    ],
  );
}
