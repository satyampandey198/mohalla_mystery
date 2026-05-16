// lib/screens/mystery_solved_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../models/game_models.dart';
import 'chapter_select_screen.dart';

class MysterySolvedScreen extends StatelessWidget {
  final Chapter chapter;
  final Character culprit;
  final int score;

  const MysterySolvedScreen({
    super.key,
    required this.chapter,
    required this.culprit,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Victory emoji
                const Text('🎊', style: TextStyle(fontSize: 80))
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                      duration: 800.ms,
                    ),

                const SizedBox(height: 24),

                Text(
                  'RAAZ SULAJH GAYA!',
                  style: GoogleFonts.cinzelDecorative(
                    color: AppTheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    shadows: [
                      const Shadow(color: AppTheme.glow, blurRadius: 30),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms).shimmer(
                      delay: 1000.ms,
                      duration: 2000.ms,
                    ),

                const SizedBox(height: 8),

                Text(
                  chapter.title,
                  style: GoogleFonts.notoSansDevanagari(
                      color: AppTheme.textSecondary, fontSize: 16),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 32),

                // Culprit reveal card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: HorrorDecorations.glowDecoration,
                  child: Column(
                    children: [
                      Text(
                        'MUJRIM:',
                        style: GoogleFonts.cinzel(
                          color: AppTheme.accent,
                          fontSize: 12,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(culprit.emoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),
                      Text(
                        culprit.name,
                        style: GoogleFonts.cinzelDecorative(
                          color: AppTheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        culprit.role,
                        style: GoogleFonts.notoSansDevanagari(
                            color: AppTheme.accent, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: AppTheme.primary.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Wajah:',
                        style: GoogleFonts.cinzel(
                            color: AppTheme.textMuted,
                            fontSize: 10,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        culprit.description,
                        style: GoogleFonts.notoSansDevanagari(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms).scale(
                    begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),

                const SizedBox(height: 24),

                // Score
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TOTAL SCORE',
                        style: GoogleFonts.cinzel(
                          color: AppTheme.textMuted,
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$score',
                        style: GoogleFonts.cinzelDecorative(
                          color: AppTheme.primary,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Excellent Detective!',
                        style: GoogleFonts.notoSansDevanagari(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1000.ms),

                const SizedBox(height: 32),

                // Buttons
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const ChapterSelectScreen()),
                        (route) => route.isFirst,
                      ),
                      icon: const Text('🗺️'),
                      label: const Text('AGLI CHAPTER KHELO'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                      icon: const Text('🏠'),
                      label: Text(
                        'MAIN MENU',
                        style: GoogleFonts.cinzel(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: AppTheme.textMuted),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
