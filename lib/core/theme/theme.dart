import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.woltBlue]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1.2),
    borderRadius: BorderRadius.circular(10),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.woltBlue,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.woltMediumBlue),
    ),
  );
}
