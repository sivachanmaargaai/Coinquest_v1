import 'package:flutter/material.dart';

/// CoinQuest Design System — Locked Color Palette
/// DO NOT change these values without updating the design system doc.
class AppColors {
  AppColors._(); // prevent instantiation

  // Primary
  static const Color primaryPurple = Color(0xFF5B3DF5);
  static const Color darkPurple = Color(0xFF2A235A);
  static const Color goldAccent = Color(0xFFFFC83D);
  static const Color successGreen = Color(0xFF34C759);

  // Backgrounds
  static const Color backgroundStart = Color(0xFF1B1235);
  static const Color backgroundEnd = Color(0xFF4E2EFF);
  static const Color cardBackground = Color(0xFF241B4D); // used at 80% opacity

  // Text
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFCFC8FF);

  // Extra
  static const Color warning = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF6EE7FF);

  /// Primary background gradient used on most screens
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  /// Glassmorphism card background (80% opacity dark purple)
  static Color get glassCard => cardBackground.withOpacity(0.8);
}
