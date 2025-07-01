import 'package:flutter/material.dart';

class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier(ThemeMode value) : super(value);
}

final themeModeNotifier = ThemeModeNotifier(ThemeMode.system);
