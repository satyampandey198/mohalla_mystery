// lib/screens/main_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';
import '../utils/app_strings.dart';
import '../services/game_provider.dart';
import '../services/ad_service.dart';
import 'chapter_select_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLanguage());
  }

  void _checkLanguage() async {
    final prefs = await _getPrefs();
    final hasChosen = prefs.containsKey('language');
    if (!hasChosen && mounted) {
      _showLanguageDialog();
    }
  }

  Future<dynamic> _getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌐', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                'BHASHA CHUNIYE',
                style: GoogleFonts.cinzelDecorative(
                    color: AppTheme.primary, fontSize: 16, letterSpacing: 2),
              ),
              Text(
                'Choose Language',
                style: GoogleFonts.cinzel(
                    color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              _LanguageButton(
                emoji: '🇮🇳',
                title: 'हिंदी',
                subtitle: 'Hindi',
                onTap: () {
                  context.read<GameProvider>().setLanguage('hindi');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _LanguageButton(
                emoji: '🇬🇧',
                title: 'English',
                subtitle: 'English',
                onTap: () {
                  context.read<GameProvider>().setLanguage('english');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Stack(
        children: [
          // Background atmospheric elements
          _buildBackground(),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Game Title
                _buildTitle(),

                const Spacer(),

                // Menu Buttons
                _buildMenuButtons(context, gameProvider),

                const SizedBox(height: 20),

                // Stats row
                _buildStatsRow(gameProvider),

                const SizedBox(height: 20),

                // Banner Ad
                const BannerAdWidget(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _AtmospherePainter(),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        // Animated eye emoji
        const Text('👁️', style: TextStyle(fontSize: 64))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms),

        const SizedBox(height: 16),

        Text(
          AppStrings.get('game_title', context.read<GameProvider>().language),
          style: GoogleFonts.cinzelDecorative(
            color: AppTheme.primary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            shadows: [
              const Shadow(color: AppTheme.glow, blurRadius: 20),
              const Shadow(color: AppTheme.glow, blurRadius: 40),
            ],
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms).shimmer(
              delay: 1000.ms,
              duration: 2000.ms,
              color: AppTheme.primary.withValues(alpha: 0.8),
            ),

        const SizedBox(height: 8),

        Text(
          AppStrings.get('game_subtitle', context.read<GameProvider>().language),
          style: GoogleFonts.notoSansDevanagari(
            color: AppTheme.textSecondary,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            AppStrings.get('tagline', context.read<GameProvider>().language),
            style: GoogleFonts.cinzel(
              color: AppTheme.accent,
              fontSize: 10,
              letterSpacing: 3,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, GameProvider gameProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Main CTA
          _MenuButton(
            label: AppStrings.get('btn_start', gameProvider.language),
            subtitle: AppStrings.get('btn_start_sub', gameProvider.language),
            emoji: '🔍',
            isPrimary: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChapterSelectScreen()),
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _MenuButton(
                  label: AppStrings.get('btn_hints', gameProvider.language),
                  emoji: '💡',
                  score: gameProvider.hintsRemaining,
                  onTap: () => _showHintsDialog(context, gameProvider),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MenuButton(
                  label: AppStrings.get('btn_language', gameProvider.language),
                  emoji: '🌐',
                  onTap: () => _showLanguageDialog(),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 12),

          _MenuButton(
            label: AppStrings.get('btn_how_to_play', gameProvider.language),
            subtitle: AppStrings.get('btn_how_to_play_sub', gameProvider.language),
            emoji: '📖',
            onTap: () => _showHowToPlay(context),
          ).animate().fadeIn(delay: 1100.ms),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GameProvider gameProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatChip(
            label: AppStrings.get('stats_chapters', gameProvider.language),
            value: '${gameProvider.gameState.completedChapters.length}/3',
            emoji: '⚰️',
          ),
          const SizedBox(width: 16),
          _StatChip(
            label: AppStrings.get('stats_score', gameProvider.language),
            value: '${gameProvider.gameState.totalScore}',
            emoji: '💀',
          ),
        ],
      ).animate().fadeIn(delay: 1200.ms),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kaise Khelen? 🔍',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              ...[
                ('🗺️', 'Mohalle mein ghoom kar jagah dhundho'),
                ('🔍', 'Suspicious jagahon ko tap karke clues khojo'),
                ('👥', 'Padosiyon se baat karo, unke jawab sunno'),
                ('📝', 'Notes mein saare clues dekho'),
                ('🎯', 'Sahi qusoorwar ka ilzaam lagao'),
                ('💡', 'Hint chahiye toh ad dekho - 3 hints milenge'),
              ].map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.$2,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('SAMAJH GAYA!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showHintsDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.bgCard,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💡 ${AppStrings.get('btn_hints', gameProvider.language)}',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              Text(
                '${gameProvider.hintsRemaining} ${AppStrings.get('hint_remaining', gameProvider.language)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              if (AdService().isRewardedAdReady)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    AdService().showRewardedAd(
                      onRewarded: (reward) {
                        gameProvider.addHints(3);
                      },
                    );
                  },
                  icon: const Icon(Icons.play_circle),
                  label: Text(AppStrings.get('btn_watch_ad', gameProvider.language)),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.get('btn_cancel', gameProvider.language),
                    style: const TextStyle(color: AppTheme.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Menu Button Widget ────────────────────────────
class _MenuButton extends StatelessWidget {
  final String label;
  final String? subtitle;
  final String emoji;
  final bool isPrimary;
  final int? score;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.emoji,
    required this.onTap,
    this.subtitle,
    this.isPrimary = false,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: isPrimary ? 18 : 14,
        ),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.2),
                    Colors.transparent
                  ],
                )
              : null,
          color: isPrimary ? null : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isPrimary
                ? AppTheme.primary.withValues(alpha: 0.6)
                : const Color(0xFF2A2A35),
            width: isPrimary ? 1.5 : 1,
          ),
          boxShadow: isPrimary
              ? [const BoxShadow(color: AppTheme.glow, blurRadius: 20)]
              : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: isPrimary ? 24 : 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: GoogleFonts.cinzel(
                        color:
                            isPrimary ? AppTheme.primary : AppTheme.textPrimary,
                        fontSize: isPrimary ? 16 : 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (score != null)
              Text(
                '$score',
                style: GoogleFonts.cinzelDecorative(
                    color: AppTheme.primary, fontSize: 20),
              ),
            if (isPrimary)
              const Icon(Icons.arrow_forward_ios,
                  color: AppTheme.primary, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Chip ────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatChip(
      {required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2A2A35)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.cinzel(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              Text(label,
                  style: GoogleFonts.notoSansDevanagari(
                      color: AppTheme.textMuted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Custom Background Painter ────────────────────
class _AtmospherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Top corner glow
    paint.color = AppTheme.accent.withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width, 0), 200, paint);

    // Bottom glow
    paint.color = AppTheme.primary.withValues(alpha: 0.03);
    canvas.drawCircle(Offset(0, size.height), 250, paint);

    // Subtle grid lines
    paint.color = const Color(0xFF1A1A20);
    paint.strokeWidth = 0.5;
    paint.style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Language Button ───────────────────────────────
class _LanguageButton extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: GoogleFonts.cinzel(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: AppTheme.primary, size: 16),
          ],
        ),
      ),
    );
  }
}
