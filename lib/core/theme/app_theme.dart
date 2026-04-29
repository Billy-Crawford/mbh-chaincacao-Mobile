import 'package:flutter/material.dart';

class AppTheme {
  static const Color cacao = Color(0xFF5C3A21);
  static const Color green = Color(0xFF2F6B3F);
  static const Color beige = Color(0xFFF6F1E7);

  static ThemeData lightTheme = ThemeData(
    primaryColor: cacao,
    scaffoldBackgroundColor: beige,
    colorScheme: ColorScheme.light(
      primary: cacao,
      secondary: green,
    ),
    useMaterial3: true,
  );
}
