import 'package:flutter/material.dart';

class AppColors {
  // Primary Background (Deep Teal/Night)
  static const Color background = Color(0xFF0B141A);
  
  // Surface Color (Blue-Grey)
  static const Color surface = Color(0xFF1A2634);
  
  // Primary Accent (Cinematic Amber)
  static const Color primaryAccent = Color(0xFFF5A623);
  
  // Secondary Accent (Volumetric Cyan)
  static const Color secondaryAccent = Color(0xFF00E5FF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE0E6ED);
  static const Color textSecondary = Color(0xFF8899A6);
  
  // Gradient for posters
  static const LinearGradient posterGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xFF0B141A),
      Colors.transparent,
    ],
    stops: [0.0, 0.5],
  );
}
