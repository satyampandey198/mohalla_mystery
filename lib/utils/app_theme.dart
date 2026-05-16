// lib/utils/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Horror Color Palette ───────────────────────
  static const Color bgDeep = Color(0xFF0A0A0F);
  static const Color bgCard = Color(0xFF12121A);
  static const Color bgSurface = Color(0xFF1A1A25);
  static const Color primary = Color(0xFFD4A017); // Diya ki roshni (gold)
  static const Color accent = Color(0xFFB5451B); // Khoon jaisa laal
  static const Color accentBlue = Color(0xFF2D5A8E); // Raat ka neela
  static const Color textPrimary = Color(0xFFF5ECD7); // Purani kagaz jaisi
  static const Color textSecondary = Color(0xFF9A8E7A);
  static const Color textMuted = Color(0xFF5A5040);
  static const Color success = Color(0xFF4A7C59);
  static const Color warning = Color(0xFFD4A017);
  static const Color danger = Color(0xFFB5451B);
  static const Color glow = Color(0x33D4A017);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDeep,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: bgCard,
        error: danger,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzelDecorative(
          color: primary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.cinzelDecorative(
          color: primary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.cinzel(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
        headlineMedium: GoogleFonts.cinzel(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.notoSansDevanagari(
          color: textPrimary,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.notoSansDevanagari(
          color: textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.cinzel(
          color: primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: bgDeep,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF2A2A35), width: 1),
        ),
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgDeep,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzelDecorative(
          color: primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ─── Reusable Horror Decorations ──────────────────
class HorrorDecorations {
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A35), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get glowDecoration => BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.5), width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.glow,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      );

  static BoxDecoration get dangerDecoration => BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppTheme.accent.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      );
}
