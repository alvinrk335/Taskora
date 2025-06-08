import 'package:flutter/material.dart';

class AppFontStyle {
  // Const styles (tidak tergantung context)
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
  );

  // Context-aware styles (untuk adaptasi tema)
  static TextStyle titleLarge(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onBackground,
      );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onBackground,
      );

  static TextStyle taskTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onBackground,
      );

  static TextStyle bodyText(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.87),
      );
}
