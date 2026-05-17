// lib/widgets/loading_screen.dart
// ============================================================
// Jab Firebase se data fetch ho raha ho tab ye screen show hoti hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/game_provider.dart';

class FirebaseLoadingWrapper extends StatelessWidget {
  final Widget child;
  const FirebaseLoadingWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    if (provider.isLoading) {
      return const _LoadingScreen();
    }

    if (provider.loadingState == LoadingState.error) {
      return _ErrorScreen(
        message: provider.errorMessage ?? 'Kuch gadbad ho gayi',
        onRetry: () => provider.loadChaptersFromFirebase(),
      );
    }

    // New chapter notification
    if (provider.hasNewChapter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewChapterDialog(context, provider);
      });
    }

    return child;
  }

  void _showNewChapterDialog(BuildContext context, GameProvider provider) {
    provider.dismissNewChapterNotification();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppTheme.primary.withOpacity(0.6)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text(
                'NAYA CHAPTER AAYA!',
                style: GoogleFonts.cinzelDecorative(
                  color: AppTheme.primary,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ek naya raaz tumhara intezaar kar raha hai...',
                style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('DEKHTE HAIN! 🔍'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Loading Screen ───────────────────────────────
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👁️', style: TextStyle(fontSize: 64))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                ),
            const SizedBox(height: 32),
            Text(
              'Mohalla load ho raha hai...',
              style: GoogleFonts.notoSansDevanagari(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.bgSurface,
                  valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                  minHeight: 4,
                ),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms),
            const SizedBox(height: 16),
            Text(
              'Chapters download ho rahe hain...',
              style: GoogleFonts.cinzel(
                color: AppTheme.textMuted,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn().then().fadeOut(duration: 800.ms),
          ],
        ),
      ),
    );
  }
}

// ─── Error Screen ─────────────────────────────────
class _ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorScreen({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📵', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 24),
              Text(
                'Connection Nahi Mili',
                style: GoogleFonts.cinzelDecorative(
                  color: AppTheme.danger,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('DOBARA TRY KARO'),
              ),
              const SizedBox(height: 12),
              Text(
                'Ya internet band ho toh purana data load hoga',
                style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
