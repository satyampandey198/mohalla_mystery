// lib/services/sound_service.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService with WidgetsBindingObserver {
  // ─── Singleton ────────────────────────────────────
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  // ─── Players ──────────────────────────────────────
  final AudioPlayer _bgPlayer = AudioPlayer();   // Background music
  final AudioPlayer _sfxPlayer = AudioPlayer();  // Sound effects

  // ─── Settings ─────────────────────────────────────
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.4;  // 0.0 to 1.0
  double _sfxVolume = 0.8;

  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  // ─── Initialize ───────────────────────────────────
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadSettings();
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(_musicVolume);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  // ─── App Lifecycle (background mein pause) ────────
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _bgPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_musicEnabled) _bgPlayer.resume();
    }
  }

  // ============================================================
  // BACKGROUND MUSIC
  // ============================================================

  Future<void> playBgMusic() async {
    if (!_musicEnabled) return;
    await _bgPlayer.stop();
    await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
  }

  Future<void> pauseBgMusic() async => await _bgPlayer.pause();
  Future<void> resumeBgMusic() async {
    if (_musicEnabled) await _bgPlayer.resume();
  }
  Future<void> stopBgMusic() async => await _bgPlayer.stop();

  // ============================================================
  // SOUND EFFECTS — Game ke har event pe call karo
  // ============================================================

  /// Clue milne pe — investigation_screen.dart mein
  Future<void> playClueFound() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/clue_found.mp3'));
  }

  /// Dialogue open hone pe — dialogue_screen.dart mein
  Future<void> playDialogueOpen() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/dialogue_open.mp3'));
  }

  /// Spot tap karne pe — investigation_screen.dart mein
  Future<void> playTapExamine() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/tap_examine.mp3'));
  }

  /// Mystery solve hone pe — mystery_solved_screen.dart mein
  Future<void> playMysterySolved() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/mystery_solved.wav'));
  }

  /// Galat accusation — accusation_screen.dart mein
  Future<void> playWrongAccusation() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/wrong_accusation.wav'));
  }

  /// Button tap — kisi bhi button pe
  Future<void> playButtonTap() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/button_tap.wav'));
  }

  /// Naya chapter unlock — chapter_select_screen.dart mein
  Future<void> playChapterUnlock() async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audio/chapter_unlock.wav'));
  }

  // ============================================================
  // SETTINGS CONTROL
  // ============================================================

  Future<void> toggleMusic() async {
    _musicEnabled = !_musicEnabled;
    if (_musicEnabled) {
      await playBgMusic();
    } else {
      await _bgPlayer.pause();
    }
    await _saveSettings();
  }

  Future<void> toggleSfx() async {
    _sfxEnabled = !_sfxEnabled;
    await _saveSettings();
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _bgPlayer.setVolume(_musicVolume);
    await _saveSettings();
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _saveSettings();
  }

  // ─── SharedPreferences ────────────────────────────
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setBool('sfx_enabled', _sfxEnabled);
    await prefs.setDouble('music_volume', _musicVolume);
    await prefs.setDouble('sfx_volume', _sfxVolume);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    _sfxEnabled = prefs.getBool('sfx_enabled') ?? true;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.4;
    _sfxVolume = prefs.getDouble('sfx_volume') ?? 0.8;
  }

  // ─── Dispose ──────────────────────────────────────
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
