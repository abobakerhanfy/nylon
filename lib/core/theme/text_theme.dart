// lib/core/theme/text_theme.dart
import 'package:flutter/material.dart';

TextTheme buildBaseTextTheme() {
  // بدون ألوان نهائيًا — AppThemeController.applyTo هو اللي هيفرض ألوان الـ API
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );
}
