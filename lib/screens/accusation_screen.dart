// lib/screens/accusation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../utils/app_theme.dart';
import '../services/game_provider.dart';
import '../services/sound_service.dart';
import '../models/game_models.dart';
import '../utils/app_strings.dart';
import 'mystery_solved_screen.dart';

class AccusationScreen extends StatefulWidget {
  final Chapter chapter;

  const AccusationScreen({super.key, required this.chapter});

  @override
  State<AccusationScreen> createState() => _AccusationScreenState();
}

class _AccusationScreenState extends State<AccusationScreen> {
  String? _selectedSuspect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        title: Text(
          AppStrings.get('btn_accuse', context.read<GameProvider>().language),
          style: GoogleFonts.cinzelDecorative(
              color: AppTheme.accent, fontSize: 16, letterSpacing: 2),
        ),
        backgroundColor: AppTheme.bgDeep,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accent.withValues(alpha: 0.15),
                      Colors.transparent
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.get('think_carefully', context.read<GameProvider>().language),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppTheme.accent)),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.get('accuse_warning', context.read<GameProvider>().language),
                            style: GoogleFonts.notoSansDevanagari(
                                color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.2),

              const SizedBox(height: 24),

              Text(
                AppStrings.get('who_is_guilty', context.read<GameProvider>().language),
                style: Theme.of(context).textTheme.headlineLarge,
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 4),

              Text(
                AppStrings.get('choose_suspect', context.read<GameProvider>().language),
                style: GoogleFonts.notoSansDevanagari(
                    color: AppTheme.textSecondary, fontSize: 13),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 20),

              // Suspect list
              Expanded(
                child: ListView.builder(
                  itemCount: widget.chapter.characters.length,
                  itemBuilder: (_, i) {
                    final character = widget.chapter.characters[i];
                    final isSelected = _selectedSuspect == character.id;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedSuspect = character.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accent.withValues(alpha: 0.15)
                              : AppTheme.bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accent
                                : const Color(0xFF2A2A35),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.accent.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                  )
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            // Selection indicator
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppTheme.accent
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.accent
                                      : AppTheme.textMuted,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 14)
                                  : null,
                            ),

                            const SizedBox(width: 14),

                            Text(character.emoji,
                                style: const TextStyle(fontSize: 30)),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(character.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  Text(character.role,
                                      style: GoogleFonts.notoSansDevanagari(
                                          color: AppTheme.accent,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 200 * i));
                  },
                ),
              ),

              // Accuse Button
              AnimatedOpacity(
                opacity: _selectedSuspect != null ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: _selectedSuspect != null ? _submitAccusation : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accent, AppTheme.danger],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _selectedSuspect != null
                          ? [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.5),
                                blurRadius: 20,
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎯', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(
                          _selectedSuspect != null
                              ? AppStrings.get('this_is_culprit', context.read<GameProvider>().language)
                              : AppStrings.get('choose_suspect_btn', context.read<GameProvider>().language),
                          style: GoogleFonts.cinzelDecorative(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAccusation() {
    if (_selectedSuspect == null) return;

    Vibration.vibrate(duration: 100);
    SoundService().playButtonTap(); // 🔊 Button tap

    final gameProvider = context.read<GameProvider>();
    final isCorrect = gameProvider.submitAccusation(_selectedSuspect!);

    if (isCorrect) {
      SoundService().playMysterySolved(); // 🔊 Sahi accusation
    } else {
      SoundService().playWrongAccusation(); // 🔊 Galat accusation
    }

    final selectedChar = widget.chapter.characters.firstWhere(
      (c) => c.id == _selectedSuspect,
    );

    // Show dramatic reveal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _RevealDialog(
        character: selectedChar,
        isCorrect: isCorrect,
        chapter: widget.chapter,
        language: gameProvider.language,
        onContinue: () {
          Navigator.pop(context); // close dialog
          if (isCorrect) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MysterySolvedScreen(
                  chapter: widget.chapter,
                  culprit: selectedChar,
                  score: gameProvider.gameState.totalScore,
                ),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          } else {
            Navigator.pop(context); // go back to investigation
          }
        },
      ),
    );
  }
}

// ─── Dramatic Reveal Dialog ───────────────────────
class _RevealDialog extends StatelessWidget {
  final Character character;
  final bool isCorrect;
  final Chapter chapter;
  final VoidCallback onContinue;
  final String language;

  const _RevealDialog({
    required this.character,
    required this.isCorrect,
    required this.chapter,
    required this.onContinue,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.bgDeep,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCorrect ? AppTheme.success : AppTheme.danger,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isCorrect
                  ? AppTheme.success.withValues(alpha: 0.4)
                  : AppTheme.danger.withValues(alpha: 0.4),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCorrect ? '✅' : '❌',
              style: const TextStyle(fontSize: 60),
            ).animate().scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(
              isCorrect ? AppStrings.get('correct_guess', language) : AppStrings.get('wrong_guess', language),
              style: GoogleFonts.cinzelDecorative(
                color: isCorrect ? AppTheme.success : AppTheme.danger,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            Text(
              isCorrect
                  ? '${character.name} ${AppStrings.get('is_culprit', language)}'
                  : '${character.name} ${AppStrings.get('is_not_culprit', language)}',
              style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.textPrimary, fontSize: 15),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 500.ms),
            if (isCorrect) ...[
              const SizedBox(height: 12),
              Text(
                '+500 points!',
                style: GoogleFonts.cinzelDecorative(
                    color: AppTheme.primary, fontSize: 20),
              ).animate().fadeIn(delay: 700.ms),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? AppTheme.success : AppTheme.bgCard,
                foregroundColor: Colors.white,
              ),
              child: Text(isCorrect ? AppStrings.get('mystery_solved_btn', language) : AppStrings.get('go_back', language)),
            ).animate().fadeIn(delay: 900.ms),
          ],
        ),
      ),
    );
  }
}
