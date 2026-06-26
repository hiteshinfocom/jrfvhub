import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // ================= LIGHT THEME =================

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.light,

    primaryColor: const Color(0xFF1565C0),

    scaffoldBackgroundColor: const Color(0xFFF5F7FA),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.light,
    ),

    // ================= APP BAR =================

    appBarTheme: AppBarTheme(

      elevation: 0,

      centerTitle: true,

      backgroundColor: Colors.white,

      foregroundColor: Colors.black,

      titleTextStyle: GoogleFonts.poppins(

        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,

      ),
    ),

    // ================= TEXT THEME =================

    textTheme: TextTheme(

      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),

      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black87,
      ),

      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),

    // ================= CARD =================

    cardTheme: CardThemeData(

      elevation: 4,

      shadowColor: Colors.black12,

      color: Colors.white,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(18),

      ),
    ),

    // ================= INPUT =================

    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(

        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,

      ),

      enabledBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: Color(0xFF1565C0),
          width: 1.5,
        ),
      ),

      labelStyle: GoogleFonts.poppins(
        color: Colors.grey.shade700,
      ),
    ),

    // ================= BUTTON =================

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        elevation: 0,

        backgroundColor: const Color(0xFF1565C0),

        foregroundColor: Colors.white,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(14),

        ),

        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),

        textStyle: GoogleFonts.poppins(

          fontSize: 16,
          fontWeight: FontWeight.w600,

        ),
      ),
    ),

    // ================= ICON =================

    iconTheme: const IconThemeData(

      color: Color(0xFF1565C0),

      size: 24,
    ),

    // ================= FLOATING BUTTON =================

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(

      backgroundColor: Color(0xFF1565C0),

      foregroundColor: Colors.white,

    ),

    // ================= BOTTOM NAVIGATION =================

    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(

      backgroundColor: Colors.white,

      selectedItemColor: Color(0xFF1565C0),

      unselectedItemColor: Colors.grey,

      showUnselectedLabels: true,

      type: BottomNavigationBarType.fixed,

    ),

    // ================= DIVIDER =================

    dividerColor: Colors.grey.shade300,

    // ================= PROGRESS =================

    progressIndicatorTheme:
        const ProgressIndicatorThemeData(

      color: Color(0xFF1565C0),

    ),
  );

  // ================= DARK THEME =================

  static ThemeData darkTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.dark,

    primaryColor: const Color(0xFF1565C0),

    scaffoldBackgroundColor: const Color(0xFF121212),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.dark,
    ),

    appBarTheme: AppBarTheme(

      elevation: 0,

      centerTitle: true,

      backgroundColor: const Color(0xFF1E1E1E),

      foregroundColor: Colors.white,

      titleTextStyle: GoogleFonts.poppins(

        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,

      ),
    ),

    textTheme: TextTheme(

      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),

    cardTheme: CardThemeData(

      color: const Color(0xFF1E1E1E),

      elevation: 3,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(18),

      ),
    ),
  );
}