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

  // Obsidian Theme (Pure Black/Cyan)
  static const Color obsidianBackground = Color(0xFF000000);
  static const Color obsidianSurface = Color(0xFF121212);
  static const Color obsidianAccent = Color(0xFF00E5FF);

  // Nebula Theme (Dark Purple/Pink)
  static const Color nebulaBackground = Color(0xFF1A0B2E);
  static const Color nebulaSurface = Color(0xFF2D1B4E);
  static const Color nebulaAccent = Color(0xFFE040FB);
}
