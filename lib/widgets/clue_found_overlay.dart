// lib/widgets/clue_found_overlay.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_strings.dart';
import '../services/game_provider.dart';
import '../models/game_models.dart';

class ClueFoundOverlay extends StatelessWidget {
  final Clue clue;
  final VoidCallback onDismiss;
  final bool isRevisit;

  const ClueFoundOverlay({
    super.key,
    required this.clue,
    required this.onDismiss,
    this.isRevisit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.bgDeep,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: clue.isImportant
                ? AppTheme.primary.withValues(alpha: 0.8)
                : const Color(0xFF2A2A35),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: clue.isImportant ? AppTheme.glow : Colors.black38,
              blurRadius: clue.isImportant ? 40 : 20,
              spreadRadius: clue.isImportant ? 5 : 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Found badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
              ),
              child: Text(
                isRevisit
                    ? AppStrings.get('clue_revisit', context.read<GameProvider>().language)
                    : AppStrings.get('clue_found', context.read<GameProvider>().language),
                style: GoogleFonts.cinzel(
                  color: AppTheme.primary,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.5, 0.5)),

            const SizedBox(height: 20),

            // Clue emoji
            Text(clue.emoji, style: const TextStyle(fontSize: 64))
                .animate()
                .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut)
                .fadeIn(),

            const SizedBox(height: 16),

            Text(
              clue.name,
              style: GoogleFonts.cinzelDecorative(
                color:
                    clue.isImportant ? AppTheme.primary : AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),

            if (clue.isImportant) ...[
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                  border:
                      Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '⭐ IMPORTANT CLUE',
                  style: GoogleFonts.cinzel(
                      color: AppTheme.accent, fontSize: 9, letterSpacing: 1.5),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],

            const SizedBox(height: 16),

            // Location tag
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_pin,
                    color: AppTheme.textMuted, size: 14),
                const SizedBox(width: 4),
                Text(
                  clue.location,
                  style: GoogleFonts.cinzel(
                      color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2A2A35)),
              ),
              child: Text(
                clue.description,
                style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(AppStrings.get('btn_continue', context.read<GameProvider>().language)),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
