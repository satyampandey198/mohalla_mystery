// lib/widgets/sound_settings_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sound_service.dart';
import '../utils/app_theme.dart';

/// Settings screen ya main menu mein use karo
class SoundSettingsWidget extends StatefulWidget {
  const SoundSettingsWidget({super.key});

  @override
  State<SoundSettingsWidget> createState() => _SoundSettingsWidgetState();
}

class _SoundSettingsWidgetState extends State<SoundSettingsWidget> {
  final _sound = SoundService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚙️ SETTINGS',
              style: GoogleFonts.cinzel(
                  color: AppTheme.primary, fontSize: 13, letterSpacing: 2)),

          const SizedBox(height: 20),

          // ─── Music Toggle + Volume ──────────────────
          _SoundRow(
            label: 'Background Music',
            emoji: '🎵',
            isEnabled: _sound.musicEnabled,
            volume: _sound.musicVolume,
            onToggle: () async {
              await _sound.toggleMusic();
              setState(() {});
            },
            onVolumeChange: (v) async {
              await _sound.setMusicVolume(v);
              setState(() {});
            },
          ),

          const SizedBox(height: 16),

          // ─── SFX Toggle + Volume ───────────────────
          _SoundRow(
            label: 'Sound Effects',
            emoji: '🔔',
            isEnabled: _sound.sfxEnabled,
            volume: _sound.sfxVolume,
            onToggle: () async {
              await _sound.toggleSfx();
              // Test sound
              if (_sound.sfxEnabled) await _sound.playButtonTap();
              setState(() {});
            },
            onVolumeChange: (v) async {
              await _sound.setSfxVolume(v);
              await _sound.playButtonTap(); // Preview
              setState(() {});
            },
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2A2A35)),
          const SizedBox(height: 16),

          // ─── Theme Toggle (Easter Egg) ─────────────
          _SoundRow(
            label: 'Light Mode',
            emoji: '☀️',
            isEnabled: false,
            volume: 1.0,
            hideSlider: true,
            onToggle: () async {
              // Spooky Easter Egg
              await _sound.playButtonTap();
              if (context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('👻 The spirits prefer the dark... Light mode is locked for your safety!'),
                    backgroundColor: AppTheme.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            onVolumeChange: (_) {},
          ),
        ],
      ),
    );
  }
}

class _SoundRow extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isEnabled;
  final double volume;
  final bool hideSlider;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChange;

  const _SoundRow({
    required this.label,
    required this.emoji,
    required this.isEnabled,
    required this.volume,
    this.hideSlider = false,
    required this.onToggle,
    required this.onVolumeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.notoSansDevanagari(
                      color: AppTheme.textPrimary, fontSize: 14)),
            ),
            // Toggle Switch
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 48,
                height: 26,
                decoration: BoxDecoration(
                  color: isEnabled ? AppTheme.primary : AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                      color: isEnabled
                          ? AppTheme.primary
                          : const Color(0xFF2A2A35)),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isEnabled ? AppTheme.bgDeep : AppTheme.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Volume Slider (sirf tab dikhe jab enabled ho aur slider hide na ho)
        if (isEnabled && !hideSlider) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 28),
              Icon(Icons.volume_down, color: AppTheme.textMuted, size: 16),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    activeTrackColor: AppTheme.primary,
                    inactiveTrackColor: AppTheme.bgSurface,
                    thumbColor: AppTheme.primary,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onVolumeChange,
                  ),
                ),
              ),
              Icon(Icons.volume_up, color: AppTheme.textMuted, size: 16),
            ],
          ),
        ],
      ],
    );
  }
}

// ─── Simple Mute Button (AppBar mein use karo) ────
class MuteIconButton extends StatefulWidget {
  const MuteIconButton({super.key});

  @override
  State<MuteIconButton> createState() => _MuteIconButtonState();
}

class _MuteIconButtonState extends State<MuteIconButton> {
  final _sound = SoundService();

  @override
  Widget build(BuildContext context) {
    final allMuted = !_sound.musicEnabled && !_sound.sfxEnabled;
    return IconButton(
      icon: Icon(
        allMuted ? Icons.volume_off : Icons.volume_up,
        color: AppTheme.primary,
        size: 22,
      ),
      onPressed: () async {
        await _sound.toggleMusic();
        await _sound.toggleSfx();
        setState(() {});
      },
    );
  }
}
