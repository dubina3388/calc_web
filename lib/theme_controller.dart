import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  static const _key = 'dark_theme';
  SharedPreferences? _prefs;

  void load(SharedPreferences prefs) {
    _prefs = prefs;
    value = (prefs.getBool(_key) ?? false) ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
    _prefs?.setBool(_key, isDark);
  }
}

final themeController = ThemeController();
