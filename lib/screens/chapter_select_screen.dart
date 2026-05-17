// lib/screens/chapter_select_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_strings.dart';
import '../services/game_provider.dart';
import '../services/sound_service.dart';
import '../models/game_models.dart';
import 'investigation_screen.dart';

class ChapterSelectScreen extends StatelessWidget {
  const ChapterSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      appBar: AppBar(
        title: Text(AppStrings.get('chapter_title', gameProvider.language)),
        backgroundColor: AppTheme.bgDeep,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            AppStrings.get('chapter_subtitle', gameProvider.language),
            style: GoogleFonts.notoSansDevanagari(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          ...gameProvider.chapters.asMap().entries.map((entry) {
            final i = entry.key;
            final chapter = entry.value;
            final isCompleted = gameProvider.isChapterCompleted(chapter.id);

            return _ChapterCard(
              chapter: chapter,
              isCompleted: isCompleted,
              chapterNumber: i + 1,
              onTap: chapter.isLocked
                  ? null
                  : () => _startChapter(context, chapter),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: 200 * i))
                .slideX(begin: 0.2);
          }),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2A35)),
            ),
            child: Row(
              children: [
                const Text('🔓', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.get('coming_soon_title', gameProvider.language),
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }

  void _startChapter(BuildContext context, Chapter chapter) {
    SoundService().playChapterUnlock(); // 🔊 Chapter start sound
    context.read<GameProvider>().setCurrentChapter(chapter.id);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => InvestigationScreen(chapter: chapter),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

// ─── Chapter Card ─────────────────────────────────
class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final bool isCompleted;
  final int chapterNumber;
  final VoidCallback? onTap;

  const _ChapterCard({
    required this.chapter,
    required this.isCompleted,
    required this.chapterNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = chapter.isLocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: isCompleted
            ? HorrorDecorations.glowDecoration
            : isLocked
                ? BoxDecoration(
                    color: AppTheme.bgCard.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1A1A25)),
                  )
                : HorrorDecorations.cardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background
              Positioned(
                right: -20,
                top: -10,
                child: Text(
                  chapter.backgroundEmoji,
                  style: TextStyle(
                    fontSize: 80,
                    color:
                        Colors.white.withValues(alpha: isLocked ? 0.03 : 0.08),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Chapter number
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLocked
                                ? AppTheme.textMuted.withValues(alpha: 0.2)
                                : AppTheme.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: isLocked
                                    ? AppTheme.textMuted.withValues(alpha: 0.3)
                                    : AppTheme.accent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'CHAPTER $chapterNumber',
                            style: GoogleFonts.cinzel(
                              color: isLocked
                                  ? AppTheme.textMuted
                                  : AppTheme.accent,
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              children: [
                                const Text('✓ ',
                                    style: TextStyle(
                                        color: Color(0xFF4A7C59),
                                        fontSize: 12)),
                                Text(
                                  AppStrings.get('chapter_solved', context.read<GameProvider>().language),
                                  style: GoogleFonts.cinzel(
                                      color: const Color(0xFF4A7C59),
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        if (isLocked)
                          const Text('🔒', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      chapter.title,
                      style: GoogleFonts.cinzelDecorative(
                        color: isLocked
                            ? AppTheme.textMuted
                            : AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.subtitle,
                      style: GoogleFonts.notoSansDevanagari(
                        color: isLocked
                            ? AppTheme.textMuted.withValues(alpha: 0.5)
                            : AppTheme.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            chapter.location,
                            style: GoogleFonts.notoSansDevanagari(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isLocked) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _InfoChip('${chapter.clues.length} Clues', '🔍'),
                          const SizedBox(width: 8),
                          _InfoChip(
                              '${chapter.characters.length} Suspects', '👥'),
                        ],
                      ),
                    ],
                    if (isLocked)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          AppStrings.get('chapter_locked_msg', context.read<GameProvider>().language),
                          style: GoogleFonts.notoSansDevanagari(
                              color: AppTheme.textMuted, fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String emoji;
  const _InfoChip(this.label, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2A2A35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.cinzel(
                  color: AppTheme.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}
