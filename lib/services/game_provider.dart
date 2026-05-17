// lib/services/game_provider.dart — Firebase + Language Support
// ============================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import '../data/story_data.dart';
import 'firebase_service.dart';
import 'translation_service.dart';

enum LoadingState { idle, loading, loaded, error }

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  List<Chapter> _chapters = [];
  List<InvestigationSpot> _currentSpots = [];
  String _language = 'english'; // 'hindi' or 'english'

  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  bool _hasNewChapter = false;

  // ─── Getters ─────────────────────────────────────
  GameState get gameState => _gameState;
  List<Chapter> get chapters => _chapters;
  List<InvestigationSpot> get currentSpots => _currentSpots;
  String get language => _language;
  LoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _loadingState == LoadingState.loading;
  bool get hasNewChapter => _hasNewChapter;

  Chapter get currentChapter => _chapters.firstWhere(
        (c) => c.id == _gameState.currentChapterId,
        orElse: () => _chapters.isNotEmpty ? _chapters.first : _emptyChapter(),
      );

  List<Clue> get foundClues => currentChapter.clues
      .where((c) => _gameState.foundClues.contains(c.id))
      .toList();

  int get foundClueCount => foundClues.length;
  int get totalClues => currentChapter.clues.length;
  int get hintsRemaining => _gameState.hintsRemaining;

  GameProvider() {
    _gameState = GameState();
    _initializeGame();
  }

  // ============================================================
  // INIT: Saved state load karo, phir Firebase se chapters
  // ============================================================
  Future<void> _initializeGame() async {
    await _loadSavedState();
    await loadChaptersFromFirebase();
  }

  Future<void> loadChaptersFromFirebase() async {
    _loadingState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Check Internet First
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) throw Exception();
      } catch (_) {
        _errorMessage = 'Internet connection nahi hai. Kripya on karein aur retry karein.';
        _loadingState = LoadingState.error;
        notifyListeners();
        return; // Stop right here
      }

      final previousCount = _chapters.length;
      _chapters = await FirebaseService().fetchAllChapters();

      if (previousCount > 0 && _chapters.length > previousCount) {
        _hasNewChapter = true;
      }

      _updateChapterLocks();
      _updateCurrentSpots();

      _loadingState = LoadingState.loaded;

      if (_language == 'english') {
        _translateAllChaptersProgressively();
      }

    } catch (e) {
      _errorMessage = 'Chapters load nahi hue. Internet check karke retry karein.';
      _loadingState = LoadingState.error;
      _chapters.clear(); // Ensure it forces retry instead of silent fail
    }

    notifyListeners();
  }

  // Specific chapter refresh karo (pull-to-refresh ke liye)
  Future<void> refreshChapter(String chapterId) async {
    final updated = await FirebaseService().refreshChapter(chapterId);
    if (updated != null) {
      final index = _chapters.indexWhere((c) => c.id == chapterId);
      if (index != -1) {
        _chapters[index] = updated;
        _updateCurrentSpots();
        notifyListeners();
      }
    }
  }

  void _updateCurrentSpots() {
    if (_chapters.isEmpty) return;

    // Prefer chapter.spots (from Firebase); fallback to StoryData
    if (currentChapter.spots.isNotEmpty) {
      _currentSpots = currentChapter.spots;
    } else {
      _currentSpots = StoryData.getSpotsForChapter(
          _gameState.currentChapterId, _language);
    }

    // Previously found clues ke spots mark karo
    for (var spot in _currentSpots) {
      if (spot.clueId != null && _gameState.foundClues.contains(spot.clueId)) {
        spot.isExamined = true;
      }
    }
  }

  // Unlock chapters based on completed chapters list
  void _updateChapterLocks() {
    for (int i = 0; i < _chapters.length; i++) {
      if (i == 0) {
        _chapters[i] = _chapters[i].copyWith(isLocked: false);
      } else {
        final prevChapterId = _chapters[i - 1].id;
        final shouldUnlock = _gameState.completedChapters.contains(prevChapterId);
        _chapters[i] = _chapters[i].copyWith(isLocked: !shouldUnlock);
      }
    }
  }

  void dismissNewChapterNotification() {
    _hasNewChapter = false;
    notifyListeners();
  }

  // ============================================================
  // Language Support
  // ============================================================
  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);

    if (_loadingState != LoadingState.loading) {
      if (lang == 'english') {
        _translateAllChaptersProgressively();
      } else {
        await loadChaptersFromFirebase(); // re-load hindi originals
      }
    }
  }

  Future<void> _translateAllChaptersProgressively() async {
    for (int i = 0; i < _chapters.length; i++) {
      if (_language != 'english') break; // stop if switched back
      try {
        if (_chapters[i].id == _gameState.currentChapterId) {
          // Fully translate only the current playing chapter
          _chapters[i] = await TranslationService.translateChapter(_chapters[i]);
        } else {
          // Only translate titles for menus to save time
          _chapters[i] = await TranslationService.translateChapterBasicInfo(_chapters[i]);
        }
        
        if (i < 5 || i % 5 == 0 || _chapters[i].id == _gameState.currentChapterId) {
          notifyListeners(); // Update UI selectively to avoid jank
        }
      } catch (e) {
        print("Progressive translation error: $e");
      }
    }
    notifyListeners();
    _updateCurrentSpots();
  }


  // ============================================================
  // Saved State Load/Save
  // ============================================================
  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'english';
    _gameState = GameState(
      completedChapters: Set.from(prefs.getStringList('completed_chapters') ?? []),
      foundClues: Set.from(prefs.getStringList('found_clues') ?? []),
      hintsRemaining: prefs.getInt('hints_remaining') ?? 3,
      totalScore: prefs.getInt('total_score') ?? 0,
      currentChapterId: prefs.getString('current_chapter') ?? 'chapter_1',
    );
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'completed_chapters', _gameState.completedChapters.toList());
    await prefs.setStringList('found_clues', _gameState.foundClues.toList());
    await prefs.setInt('hints_remaining', _gameState.hintsRemaining);
    await prefs.setInt('total_score', _gameState.totalScore);
    await prefs.setString('current_chapter', _gameState.currentChapterId);
  }

  // ============================================================
  // Game Logic
  // ============================================================
  Clue? examineSpot(String spotId) {
    final spot = _currentSpots.firstWhere((s) => s.id == spotId);

    if (spot.isExamined) {
      // Re-show clue if already found
      if (spot.clueId != null) {
        return currentChapter.clues.firstWhere((c) => c.id == spot.clueId);
      }
      return null;
    }

    spot.isExamined = true;

    if (spot.clueId != null) {
      _gameState.foundClues.add(spot.clueId!);
      _gameState.totalScore += 100;
      _saveState();
      notifyListeners();
      return currentChapter.clues.firstWhere((c) => c.id == spot.clueId);
    }

    notifyListeners();
    return null;
  }

  bool isDialogueAccessible(DialogueBranch dialogue) {
    if (!dialogue.isHidden) return true;
    if (dialogue.requiredClueId == null) return true;
    return _gameState.foundClues.contains(dialogue.requiredClueId);
  }

  void triggerDialogue(String characterId, String dialogueId) {
    final char = currentChapter.characters.firstWhere((c) => c.id == characterId);
    char.hasSpoken = true;

    final dialogue = char.dialogues.firstWhere((d) => d.id == dialogueId);
    if (dialogue.revealClue != null) {
      _gameState.foundClues.add(dialogue.revealClue!);
      _gameState.totalScore += 50;
    }
    _saveState();
    notifyListeners();
  }

  bool useHint() {
    if (_gameState.hintsRemaining <= 0) return false;
    _gameState.hintsRemaining--;
    _saveState();
    notifyListeners();
    return true;
  }

  void addHints(int count) {
    _gameState.hintsRemaining += count;
    _gameState.hasWatchedAd = true;
    _saveState();
    notifyListeners();
  }

  String getHint() {
    final unfound = currentChapter.clues
        .where((c) => c.isImportant && !_gameState.foundClues.contains(c.id))
        .toList();
    if (unfound.isEmpty) return 'Tum sahi raste par ho! Suspects se zyada baat karo.';
    return '${unfound.first.location} ko dhyan se dekho — wahan kuch chhupta hai.';
  }

  bool submitAccusation(String characterId) {
    final isCorrect = currentChapter.solution == characterId;
    if (isCorrect) {
      _gameState.completedChapters.add(currentChapter.id);
      _gameState.totalScore += 500;

      // Unlock next chapter
      final currentIndex = _chapters.indexWhere((c) => c.id == currentChapter.id);
      if (currentIndex >= 0 && currentIndex + 1 < _chapters.length) {
        _chapters[currentIndex + 1] =
            _chapters[currentIndex + 1].copyWith(isLocked: false);
      }

      _saveState();
      notifyListeners();
    }
    return isCorrect;
  }

  bool isChapterCompleted(String chapterId) =>
      _gameState.completedChapters.contains(chapterId);

  void setCurrentChapter(String chapterId) async {
    if (_gameState.currentChapterId != chapterId) {
      _gameState.currentChapterId = chapterId;
      _updateCurrentSpots();
      _saveState();
      notifyListeners();

      // Lazy translate full chapter if english
      if (_language == 'english') {
        final index = _chapters.indexWhere((c) => c.id == chapterId);
        if (index != -1) {
          _chapters[index] = await TranslationService.translateChapter(_chapters[index]);
          _updateCurrentSpots();
          notifyListeners();
        }
      }
    }
  }

  // Reset for new game
  Future<void> resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _gameState = GameState();
    await loadChaptersFromFirebase();
  }

  Chapter _emptyChapter() => Chapter(
    id: '', title: 'Loading...', subtitle: '', location: '',
    backgroundEmoji: '⏳', mystery: '', solution: '', clues: [],
    characters: [], spots: [],
  );
}
