// lib/services/game_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import '../data/story_data.dart';

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  late List<Chapter> _chapters;
  late List<InvestigationSpot> _currentSpots;
  String _language = 'hindi'; // 'hindi' or 'english'

  GameState get gameState => _gameState;
  List<Chapter> get chapters => _chapters;
  List<InvestigationSpot> get currentSpots => _currentSpots;
  String get language => _language;

  Chapter get currentChapter => _chapters.firstWhere(
        (c) => c.id == _gameState.currentChapterId,
        orElse: () => _chapters.first,
      );

  List<Clue> get foundClues => currentChapter.clues
      .where((c) => _gameState.foundClues.contains(c.id))
      .toList();

  int get foundClueCount => foundClues.length;
  int get totalClues => currentChapter.clues.length;
  int get hintsRemaining => _gameState.hintsRemaining;

  GameProvider() {
    _gameState = GameState();
    _chapters = StoryData.getAllChapters('hindi');
    _currentSpots = StoryData.getSpotsForChapter(_gameState.currentChapterId, 'hindi');
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final completedJson = prefs.getStringList('completed_chapters') ?? [];
    final foundJson = prefs.getStringList('found_clues') ?? [];
    final hints = prefs.getInt('hints_remaining') ?? 3;
    final score = prefs.getInt('total_score') ?? 0;
    _language = prefs.getString('language') ?? 'hindi';

    _gameState = GameState(
      completedChapters: Set.from(completedJson),
      foundClues: Set.from(foundJson),
      hintsRemaining: hints,
      totalScore: score,
    );

    // Refresh data with correct language
    _chapters = StoryData.getAllChapters(_language);
    _currentSpots = StoryData.getSpotsForChapter(_gameState.currentChapterId, _language);

    // Unlock chapters based on completed chapters
    _updateChapterLocks();

    // Update spots examined status
    for (var spot in _currentSpots) {
      if (spot.clueId != null && _gameState.foundClues.contains(spot.clueId)) {
        spot.isExamined = true;
      }
    }

    notifyListeners();
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

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    
    _chapters = StoryData.getAllChapters(lang);
    _currentSpots = StoryData.getSpotsForChapter(_gameState.currentChapterId, lang);
    _updateChapterLocks();
    
    for (var spot in _currentSpots) {
      if (spot.clueId != null && _gameState.foundClues.contains(spot.clueId)) {
        spot.isExamined = true;
      }
    }
    
    notifyListeners();
  }

  void setCurrentChapter(String chapterId) {
    if (_gameState.currentChapterId != chapterId) {
      _gameState.currentChapterId = chapterId;
      _currentSpots = StoryData.getSpotsForChapter(chapterId, _language);
      
      // Update spots examined status for the new chapter
      for (var spot in _currentSpots) {
        if (spot.clueId != null && _gameState.foundClues.contains(spot.clueId)) {
          spot.isExamined = true;
        }
      }
      
      notifyListeners();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'completed_chapters', _gameState.completedChapters.toList());
    await prefs.setStringList('found_clues', _gameState.foundClues.toList());
    await prefs.setInt('hints_remaining', _gameState.hintsRemaining);
    await prefs.setInt('total_score', _gameState.totalScore);
  }

  // Examine a spot and find clue — always shows clue detail if already found
  Clue? examineSpot(String spotId) {
    final spot = _currentSpots.firstWhere((s) => s.id == spotId);

    if (spot.isExamined) {
      // Return the clue so it can be shown again (re-open)
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

  // Check if a dialogue is accessible
  bool isDialogueAccessible(DialogueBranch dialogue) {
    if (!dialogue.isHidden) return true;
    if (dialogue.requiredClueId == null) return true;
    return _gameState.foundClues.contains(dialogue.requiredClueId);
  }

  // Trigger dialogue and mark character as spoken
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

  // Use a hint
  bool useHint() {
    if (_gameState.hintsRemaining <= 0) return false;
    _gameState.hintsRemaining--;
    _saveState();
    notifyListeners();
    return true;
  }

  // Add hints (after watching ad)
  void addHints(int count) {
    _gameState.hintsRemaining += count;
    _gameState.hasWatchedAd = true;
    _saveState();
    notifyListeners();
  }

  // Get hint for current chapter
  String getHint() {
    final unfoundImportant = currentChapter.clues
        .where((c) => c.isImportant && !_gameState.foundClues.contains(c.id))
        .toList();

    if (unfoundImportant.isEmpty) {
      return 'Tum sahi raste par ho! Suspects se zyada baat karo.';
    }

    return '${unfoundImportant.first.location} ko dhyan se dekho — wahan kuch chhupta hai.';
  }

  // Submit accusation and unlock next chapter on correct answer
  bool submitAccusation(String characterId) {
    final isCorrect = currentChapter.solution == characterId;

    if (isCorrect) {
      _gameState.completedChapters.add(currentChapter.id);
      _gameState.totalScore += 500;

      // Unlock next chapter
      final currentIndex = _chapters.indexWhere((c) => c.id == currentChapter.id);
      if (currentIndex >= 0 && currentIndex + 1 < _chapters.length) {
        _chapters[currentIndex + 1] = _chapters[currentIndex + 1].copyWith(isLocked: false);
      }

      _saveState();
      notifyListeners();
    }

    return isCorrect;
  }

  bool isChapterCompleted(String chapterId) {
    return _gameState.completedChapters.contains(chapterId);
  }

  // Reset for new game
  Future<void> resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _gameState = GameState();
    _chapters = StoryData.getAllChapters(_language);
    _currentSpots = StoryData.getSpotsForChapter(_gameState.currentChapterId, _language);
    notifyListeners();
  }
}
