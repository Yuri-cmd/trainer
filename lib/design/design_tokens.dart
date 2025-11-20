// design_tokens.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1EB980);
  static const primary700 = Color(0xFF188F67);
  static const accent = Color(0xFF0F172A);
  static const bg = Color(0xFFF3F6F5);
  static const surface = Color(0xFFFFFFFF);
  static const inputFill = Color(0xFFF7F9F8);
  static const muted = Color(0xFF8F98A0);
  static const text = Color(0xFF081225);
  static const danger = Color(0xFFE53E3E);
  static const cardShadow = Color(0xFF0F172A);
}

class AppSpacing {
  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 28.0;
  static const xl = 40.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 20.0;
}

// Recomendación: en main.dart usa estas decoraciones globales
InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.8),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  );
}