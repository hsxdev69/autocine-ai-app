import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color surfaceColor = Color(0xFF1A1D27);
  static const Color cardColor = Color(0xFF232736);
  static const Color primaryNeon = Color(0xFF00E5FF);
  static const Color secondaryNeon = Color(0xFFFFB300);
  static const Color accentRed = Color(0xFFFF2A55);
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF9BA3B8);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryNeon,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryNeon,
      secondary: secondaryNeon,
      surface: surfaceColor,
      background: darkBackground,
      error: accentRed,
    ),
    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 22),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryNeon,
      unselectedItemColor: textSecondary,
      elevation: 10,
    ),
  );
}
