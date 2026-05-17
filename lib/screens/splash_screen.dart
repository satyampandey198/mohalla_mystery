// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../services/sound_service.dart';
import 'main_menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SoundService().playBgMusic(); // 🔊 Background music shuru
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainMenuScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flicker effect title
            const Text(
              '👁️',
              style: TextStyle(fontSize: 80),
            )
                .animate(onPlay: (c) => c.repeat())
                .fadeIn(duration: 600.ms)
                .then(delay: 200.ms)
                .fadeOut(duration: 300.ms)
                .then(delay: 100.ms)
                .fadeIn(duration: 400.ms)
                .then(delay: 800.ms)
                .fadeOut(duration: 200.ms)
                .then(delay: 50.ms)
                .fadeIn(duration: 600.ms),

            const SizedBox(height: 32),

            Text(
              'MOHALLA',
              style: GoogleFonts.cinzelDecorative(
                color: AppTheme.primary,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: 6,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),

            Text(
              'MYSTERY',
              style: GoogleFonts.cinzelDecorative(
                color: AppTheme.accent,
                fontSize: 22,
                fontWeight: FontWeight.w400,
                letterSpacing: 8,
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 16),

            Text(
              'मोहल्ला मिस्ट्री',
              style: GoogleFonts.notoSansDevanagari(
                color: AppTheme.textSecondary,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

            const SizedBox(height: 60),

            // Loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .fadeIn(delay: Duration(milliseconds: 1200 + i * 200))
                    .then()
                    .fadeOut(duration: 400.ms)
                    .then()
                    .fadeIn(duration: 400.ms);
              }),
            ),

            const SizedBox(height: 80),

            Text(
              'Ek Desi Horror Adventure',
              style: GoogleFonts.notoSansDevanagari(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ).animate().fadeIn(delay: 1500.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
