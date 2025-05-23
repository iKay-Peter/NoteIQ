import 'package:flutter/material.dart';

class Apptheme {
  static const Color orange = Color(0xFFFF8B2C);
  static const Color darkGreen = Color(0xFF129476);
  static const Color liteBlue = Color(0xFF37C2FF);
  static const Color black = Color(0xFF121212);
  static const Color blue = Color(0xFF557aff);
  static const Color lightRed = Color.fromRGBO(255, 120, 95, 1);
  static const Color purple = Color(0xFF8d6fff);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: orange,
    colorScheme: ColorScheme.light(primary: darkGreen, secondary: liteBlue),
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w900,
        fontSize: 24,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(fontFamily: 'Onest', fontSize: 18),
      bodyMedium: TextStyle(fontFamily: 'Onest', fontSize: 16),
      bodySmall: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w100,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Onest',
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.blue[500], fontSize: 10),
        labelStyle: TextStyle(fontSize: 10, color: Colors.blue[900]),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        errorStyle: TextStyle(color: Colors.red, fontSize: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
  );
}
