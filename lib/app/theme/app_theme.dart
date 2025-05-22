import 'package:flutter/material.dart';

class Apptheme {
  static const Color successGreen = Color(0xFF28a745);
  static const Color infoBlue = Color(0xFF17a2b8);
  static const Color dangerRed = Color(0xFFdc3545);
  static const Color warningYellow = Color(0xFFffc107);
  static const Color bgGrey = Color(0xFFF8F9FB);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: successGreen,
    colorScheme: ColorScheme.light(primary: successGreen, secondary: infoBlue),
    cardColor: Colors.white,
    scaffoldBackgroundColor: bgGrey,
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
        fontSize: 24,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(fontFamily: 'SourceSansPro', fontSize: 18),
      bodyMedium: TextStyle(fontFamily: 'SourceSansPro', fontSize: 16),
      bodySmall: TextStyle(
        fontFamily: 'SourceSansPro',
        fontWeight: FontWeight.w100,
        fontSize: 14,
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
