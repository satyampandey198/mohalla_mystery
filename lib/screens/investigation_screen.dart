// lib/screens/investigation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../utils/app_theme.dart';
import '../services/game_provider.dart';
import '../services/ad_service.dart';
import '../services/sound_service.dart';
import '../models/game_models.dart';
import 'dialogue_screen.dart';
import 'accusation_screen.dart';
import '../widgets/clue_found_overlay.dart';
import '../widgets/notes_panel.dart';
import '../utils/app_strings.dart';

class InvestigationScreen extends StatefulWidget {
  final Chapter chapter;
  const InvestigationScreen({super.key, required this.chapter});

  @override
  State<InvestigationScreen> createState() => _InvestigationScreenState();
}

class _InvestigationScreenState extends State<InvestigationScreen> {
  int _activeTab = 0; // 0: Story, 1: Map, 2: Suspects, 3: Notes

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, gameProvider),
            _buildTabBar(),
            Expanded(
              child: Stack(
                children: [
                  _buildActiveTab(context, gameProvider),
                  if (_activeTab == 3)
                    NotesPanel(
                      foundClues: gameProvider.foundClues,
                      onClose: () => setState(() => _activeTab = 1),
                    ),
                ],
              ),
            ),
            _buildBottomBar(context, gameProvider),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppTheme.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chapter.title,
                    style: GoogleFonts.cinzelDecorative(
                        color: AppTheme.primary, fontSize: 14)),
                Text(widget.chapter.location,
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textMuted, fontSize: 10)),
              ],
            ),
          ),

          // Clue Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF2A2A35)),
            ),
            child: Row(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  '${gameProvider.foundClueCount}/${gameProvider.totalClues}',
                  style: GoogleFonts.cinzel(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Hints button
          GestureDetector(
            onTap: () => _showHint(context, gameProvider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(4),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text('${gameProvider.hintsRemaining}',
                      style: GoogleFonts.cinzel(
                          color: AppTheme.primary, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActiveTab(BuildContext context, GameProvider gameProvider) {
    switch (_activeTab) {
      case 0:
        return _buildStoryView(context, gameProvider);
      case 1:
        return _buildMapView(context, gameProvider);
      case 2:
        return _buildSuspectsView(context, gameProvider);
      default:
        return _buildMapView(context, gameProvider);
    }
  }

  Widget _buildStoryView(BuildContext context, GameProvider gameProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.chapter.backgroundEmoji,
                  style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chapter.title,
                        style: GoogleFonts.cinzelDecorative(
                            color: AppTheme.primary, fontSize: 16)),
                    Text(widget.chapter.location,
                        style: GoogleFonts.notoSansDevanagari(
                            color: AppTheme.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accent.withValues(alpha: 0.12), AppTheme.bgCard],
                begin: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(8),
              border: const Border(left: BorderSide(color: AppTheme.accent, width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.get('mystery_brief_title', gameProvider.language),
                    style: GoogleFonts.cinzel(
                        color: AppTheme.accent, fontSize: 11, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text(widget.chapter.mystery,
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textPrimary, fontSize: 14, height: 1.7)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2A35)),
            ),
            child: Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.get('mystery_brief_desc', gameProvider.language),
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Row(
        children: [
          _TabButton(
            label: AppStrings.get('tab_story', context.read<GameProvider>().language),
            isActive: _activeTab == 0,
            onTap: () => setState(() => _activeTab = 0),
          ),
          _TabButton(
            label: AppStrings.get('tab_map', context.read<GameProvider>().language),
            isActive: _activeTab == 1,
            onTap: () => setState(() => _activeTab = 1),
          ),
          _TabButton(
            label: AppStrings.get('tab_suspects', context.read<GameProvider>().language),
            isActive: _activeTab == 2,
            onTap: () => setState(() => _activeTab = 2),
          ),
          _TabButton(
            label: AppStrings.get('tab_notes', context.read<GameProvider>().language),
            isActive: _activeTab == 3,
            onTap: () => setState(() => _activeTab = 3),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(BuildContext context, GameProvider gameProvider) {
    return Stack(
      children: [
        // Investigation area background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                AppTheme.bgSurface,
                AppTheme.bgDeep,
              ],
            ),
          ),
        ),

        // Atmospheric lines
        CustomPaint(
          painter: _GridPainter(),
          child: Container(),
        ),

        // Chapter location art
        Center(
          child: Opacity(
            opacity: 0.1,
            child: Text(widget.chapter.backgroundEmoji,
                style: const TextStyle(fontSize: 200)),
          ),
        ),

        // Location title
        Positioned(
          top: 16,
          left: 16,
          child: Text(
            AppStrings.get('investigation_area', gameProvider.language),
            style: GoogleFonts.cinzel(
                color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2),
          ),
        ),

        // Spot markers
        ...gameProvider.currentSpots
            .map((spot) => _buildSpotMarker(context, gameProvider, spot)),
      ],
    );
  }

  Widget _buildSpotMarker(
      BuildContext context, GameProvider gameProvider, InvestigationSpot spot) {
    final screenSize = MediaQuery.of(context).size;
    final x = spot.xPercent * screenSize.width;
    // Estimate map area height
    final mapHeight = screenSize.height * 0.45;
    final y = spot.yPercent * mapHeight;

    return Positioned(
      left: x - 28,
      top: y - 28,
      child: GestureDetector(
        onTap: () => _examineSpot(context, gameProvider, spot),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: spot.isExamined ? AppTheme.bgCard : AppTheme.bgSurface,
            border: Border.all(
              color: spot.isExamined
                  ? AppTheme.textMuted
                  : AppTheme.primary.withValues(alpha: 0.7),
              width: spot.isExamined ? 1 : 2,
            ),
            boxShadow: spot.isExamined
                ? []
                : [
                    const BoxShadow(
                      color: AppTheme.glow,
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                spot.emoji,
                style: TextStyle(fontSize: spot.isExamined ? 18 : 22),
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1.0, 1.0),
              end: spot.isExamined
                  ? const Offset(1.0, 1.0)
                  : const Offset(1.05, 1.05),
              duration: 1500.ms,
            ),
      ),
    );
  }

  Widget _buildSuspectsView(BuildContext context, GameProvider gameProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.chapter.characters.length,
      itemBuilder: (_, i) {
        final character = widget.chapter.characters[i];
        return _SuspectCard(
          character: character,
          onTap: () => _openDialogue(context, character),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 100 * i))
            .slideX(begin: 0.2);
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, GameProvider gameProvider) {
    final hasEnoughClues = gameProvider.foundClueCount >= gameProvider.totalClues;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasEnoughClues
                      ? AppStrings.get('clues_found_enough', gameProvider.language)
                      : '${gameProvider.totalClues - gameProvider.foundClueCount} ${AppStrings.get('clues_needed', gameProvider.language)}',
                  style: GoogleFonts.notoSansDevanagari(
                    color: hasEnoughClues
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value:
                        gameProvider.foundClueCount / gameProvider.totalClues,
                    backgroundColor: AppTheme.bgSurface,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: hasEnoughClues
                ? () {
                    SoundService().playButtonTap();
                    _goToAccusation(context, gameProvider);
                  }
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.get('clues_needed_snackbar', gameProvider.language),
                          style: GoogleFonts.notoSansDevanagari(),
                        ),
                        backgroundColor: AppTheme.bgCard,
                      ),
                    ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: hasEnoughClues ? AppTheme.accent : AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: hasEnoughClues
                      ? AppTheme.accent
                      : const Color(0xFF2A2A35),
                ),
                boxShadow: hasEnoughClues
                    ? [
                        BoxShadow(
                            color: AppTheme.accent.withValues(alpha: 0.4),
                            blurRadius: 15)
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.get('btn_accuse', gameProvider.language),
                    style: GoogleFonts.cinzel(
                      color: hasEnoughClues ? Colors.white : AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Actions ───────────────────────────────────

  void _examineSpot(
      BuildContext context, GameProvider gameProvider, InvestigationSpot spot) {
    SoundService().playTapExamine(); // 🔊 Spot tap sound
    Vibration.vibrate(duration: 50);

    final clue = gameProvider.examineSpot(spot.id);

    if (clue != null) {
      SoundService().playClueFound(); // 🔊 Clue found sound
      // Show clue overlay whether first time or revisiting
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ClueFoundOverlay(
          clue: clue,
          isRevisit: spot.isExamined,
          onDismiss: () => Navigator.pop(context),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: AppTheme.bgCard,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔍', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(spot.name,
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(spot.description,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text(AppStrings.get('nothing_found', gameProvider.language),
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textMuted, fontSize: 13)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.get('btn_continue', gameProvider.language)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _openDialogue(BuildContext context, Character character) {
    SoundService().playDialogueOpen(); // 🔊 Dialogue open sound
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => DialogueScreen(
          character: character,
          chapter: widget.chapter,
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _goToAccusation(BuildContext context, GameProvider gameProvider) {
    // Show interstitial ad before accusation screen
    AdService().showInterstitialAd(onComplete: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AccusationScreen(chapter: widget.chapter),
        ),
      );
    });
  }

  void _showHint(BuildContext context, GameProvider gameProvider) {
    if (gameProvider.hintsRemaining > 0) {
      final hint = gameProvider.getHint();
      gameProvider.useHint();
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: AppTheme.bgCard,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💡', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text('Detective ka Hint',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child:
                      Text(hint, style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(height: 16),
                Text(
                  '${gameProvider.hintsRemaining - 1} hints baaki hain',
                  style: GoogleFonts.notoSansDevanagari(
                      color: AppTheme.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('SHUKRIYA!')),
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: AppTheme.bgCard,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('😔', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text('Hints Khatam!',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('Ad dekho aur 3 hints pao!',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                if (AdService().isRewardedAdReady)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      AdService().showRewardedAd(
                        onRewarded: (reward) {
                          gameProvider.addHints(3);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('3 hints mil gaye! 💡')),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.play_circle),
                    label: const Text('VIDEO DEKHO — 3 HINTS PAO'),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

}

// ─── Suspect Card ─────────────────────────────────
class _SuspectCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _SuspectCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: character.hasSpoken
            ? HorrorDecorations.cardDecoration
            : BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                boxShadow: const [
                  BoxShadow(color: AppTheme.glow, blurRadius: 10)
                ],
              ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.bgSurface,
                border: Border.all(
                    color: AppTheme.primary,
                    width: 2),
              ),
              child: Center(
                child:
                    Text(character.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(character.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(character.role,
                      style: GoogleFonts.notoSansDevanagari(
                          color: AppTheme.accent, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(character.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(
              character.hasSpoken
                  ? Icons.chat_bubble
                  : Icons.chat_bubble_outline,
              color:
                  character.hasSpoken ? AppTheme.textMuted : AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSuspicionColor(int level) {
    if (level >= 70) return AppTheme.danger;
    if (level >= 40) return AppTheme.warning;
    return AppTheme.success;
  }
}

class _SuspicionBadge extends StatelessWidget {
  final int level;
  const _SuspicionBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = level >= 70
        ? AppTheme.danger
        : level >= 40
            ? AppTheme.warning
            : AppTheme.success;

    final label = level >= 70
        ? 'SUSPECT'
        : level >= 40
            ? 'WATCH'
            : 'CLEAR';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style:
              GoogleFonts.cinzel(color: color, fontSize: 9, letterSpacing: 1)),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppTheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1E2A)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
