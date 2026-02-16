import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZentraTheme {
  static ThemeData light() {
    final colorScheme = const ColorScheme.light(
      primary: Color(0xFF0F6B5A),
      secondary: Color(0xFF1E8F7A),
      surface: Color(0xFFF7F5F2),
      error: Color(0xFFB3261E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1F2A2E),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.manropeTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: colorScheme.surface,
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.manrope(color: colorScheme.onSurface),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = const ColorScheme.dark(
      primary: Color(0xFF7BD6C5),
      secondary: Color(0xFF3BAE9A),
      surface: Color(0xFF101816),
      error: Color(0xFFF2B8B5),
      onPrimary: Color(0xFF083C34),
      onSecondary: Colors.black,
      onSurface: Color(0xFFE5ECEA),
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: colorScheme.surface,
        textTheme: CupertinoTextThemeData(
          textStyle: GoogleFonts.manrope(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
