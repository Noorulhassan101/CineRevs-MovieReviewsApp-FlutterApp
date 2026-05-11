import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

extension AdaptiveThemeColors on BuildContext {
  bool get isLight => Theme.of(this).brightness == Brightness.light;
  
  Color get adaptiveWhite => isLight ? AppColors.lightTextPrimary : Colors.white;
  Color get adaptiveWhite70 => isLight ? AppColors.lightTextPrimary.withOpacity(0.7) : Colors.white70;
  Color get adaptiveWhite60 => isLight ? AppColors.lightTextSecondary.withOpacity(0.8) : Colors.white60;
  Color get adaptiveWhite54 => isLight ? AppColors.lightTextSecondary : Colors.white54;
  Color get adaptiveWhite38 => isLight ? AppColors.lightTextSecondary.withOpacity(0.6) : Colors.white38;
  Color get adaptiveWhite30 => isLight ? AppColors.lightTextSecondary.withOpacity(0.5) : Colors.white30;
  Color get adaptiveWhite24 => isLight ? AppColors.lightTextSecondary.withOpacity(0.5) : Colors.white24;
  Color get adaptiveWhite12 => isLight ? AppColors.lightTextSecondary.withOpacity(0.2) : Colors.white12;
  Color get adaptiveWhite10 => isLight ? AppColors.lightTextSecondary.withOpacity(0.1) : Colors.white10;
  
  Color get adaptiveGlass => isLight ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.05);
}
