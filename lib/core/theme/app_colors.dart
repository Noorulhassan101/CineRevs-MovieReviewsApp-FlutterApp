import 'package:flutter/material.dart';

class AppColors {
  // --- DARK THEME (MIDNIGHT) ---
  static const Color background = Color(0xFF0B141A);
  static const Color surface = Color(0xFF1A2634);
  static const Color primaryAccent = Color(0xFFF5A623); // Cinematic Amber
  static const Color secondaryAccent = Color(0xFF00E5FF); // Volumetric Cyan
  static const Color textPrimary = Color(0xFFE0E6ED);
  static const Color textSecondary = Color(0xFF8899A6);

  // --- LIGHT THEME (ZENITH) ---
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF6366F1); // Indigo
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // --- OBSIDIAN THEME (PURE DARK) ---
  static const Color obsidianBackground = Color(0xFF000000);
  static const Color obsidianSurface = Color(0xFF121212);
  static const Color obsidianAccent = Color(0xFF00E5FF); // Electric Cyan

  // --- NEBULA THEME (SPACE PURPLE) ---
  static const Color nebulaBackground = Color(0xFF0F071E);
  static const Color nebulaSurface = Color(0xFF1E0E3D);
  static const Color nebulaAccent = Color(0xFFFF00D4); // Neon Pink

  // --- FUTURISTIC ACCENTS ---
  static const Color neonCyan = Color(0xFF00F3FF);
  static const Color neonPurple = Color(0xFFBC00FF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glowColor = Color(0x8000E5FF);

  static const LinearGradient posterGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xFF0B141A),
      Colors.transparent,
    ],
    stops: [0.0, 0.5],
  );

  static LinearGradient futuristicGradient(Color primary) => LinearGradient(
    colors: [primary, primary.withOpacity(0.5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
