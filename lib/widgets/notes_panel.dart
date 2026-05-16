// lib/widgets/notes_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_strings.dart';
import '../services/game_provider.dart';
import '../models/game_models.dart';

class NotesPanel extends StatelessWidget {
  final List<Clue> foundClues;
  final VoidCallback onClose;

  const NotesPanel(
      {super.key, required this.foundClues, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.bgDeep,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📝', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(AppStrings.get('notes_title', context.read<GameProvider>().language),
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textMuted),
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (foundClues.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.get('notes_empty', context.read<GameProvider>().language),
                        style: GoogleFonts.notoSansDevanagari(
                            color: AppTheme.textSecondary, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundClues.length,
                    itemBuilder: (_, i) {
                      final clue = foundClues[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: clue.isImportant
                                ? AppTheme.primary.withValues(alpha: 0.4)
                                : const Color(0xFF2A2A35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(clue.emoji,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(clue.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                      ),
                                      if (clue.isImportant)
                                        const Text('⭐',
                                            style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    clue.description,
                                    style: GoogleFonts.notoSansDevanagari(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12,
                                        height: 1.4),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📍 ${clue.location}',
                                    style: GoogleFonts.cinzel(
                                        color: AppTheme.textMuted,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 100 * i));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms),
    );
  }
}
