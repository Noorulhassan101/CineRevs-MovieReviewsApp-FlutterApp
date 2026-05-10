import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_theme.dart';

part 'theme_controller.g.dart';

enum AppThemeMode { light, midnight, obsidian, nebula }

@riverpod
class ThemeController extends _$ThemeController {
  @override
  AppThemeMode build() => AppThemeMode.midnight;

  void setTheme(AppThemeMode mode) => state = mode;

  ThemeData get currentTheme {
    switch (state) {
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.midnight:
        return AppTheme.darkTheme;
      case AppThemeMode.obsidian:
        return AppTheme.obsidianTheme;
      case AppThemeMode.nebula:
        return AppTheme.nebulaTheme;
    }
  }

  bool get isDarkMode => state != AppThemeMode.light;
}
