// lib/models/game_models.dart

class Chapter {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final String backgroundEmoji;
  final String mystery;
  final List<Clue> clues;
  final List<Character> characters;
  final String solution;
  final bool isLocked;

  Chapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.backgroundEmoji,
    required this.mystery,
    required this.clues,
    required this.characters,
    required this.solution,
    this.isLocked = false,
  });

  Chapter copyWith({bool? isLocked}) {
    return Chapter(
      id: id,
      title: title,
      subtitle: subtitle,
      location: location,
      backgroundEmoji: backgroundEmoji,
      mystery: mystery,
      clues: clues,
      characters: characters,
      solution: solution,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class Clue {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String location;
  bool isFound;
  bool isImportant;

  Clue({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.location,
    this.isFound = false,
    this.isImportant = false,
  });
}

class Character {
  final String id;
  final String name;
  final String role;
  final String emoji;
  final String description;
  final List<DialogueBranch> dialogues;
  bool hasSpoken;
  int suspicionLevel; // 0-100

  Character({
    required this.id,
    required this.name,
    required this.role,
    required this.emoji,
    required this.description,
    required this.dialogues,
    this.hasSpoken = false,
    this.suspicionLevel = 0,
  });
}

class DialogueBranch {
  final String id;
  final String trigger; // what player says
  final String response;
  final String? revealClue;
  final bool isHidden; // needs clue to unlock
  final String? requiredClueId;
  final List<String> followUpIds;
  final bool isImportant;

  DialogueBranch({
    required this.id,
    required this.trigger,
    required this.response,
    this.revealClue,
    this.isHidden = false,
    this.requiredClueId,
    this.followUpIds = const [],
    this.isImportant = false,
  });
}

class GameState {
  String currentChapterId;
  Set<String> foundClues;
  Set<String> completedChapters;
  Map<String, int> suspicionLevels;
  int hintsRemaining;
  int totalScore;
  bool hasWatchedAd;

  GameState({
    this.currentChapterId = 'chapter_1',
    Set<String>? foundClues,
    Set<String>? completedChapters,
    Map<String, int>? suspicionLevels,
    this.hintsRemaining = 3,
    this.totalScore = 0,
    this.hasWatchedAd = false,
  })  : foundClues = foundClues ?? {},
        completedChapters = completedChapters ?? {},
        suspicionLevels = suspicionLevels ?? {};
}

class InvestigationSpot {
  final String id;
  final String name;
  final String emoji;
  final double xPercent;
  final double yPercent;
  final String? clueId;
  final String description;
  bool isExamined;

  InvestigationSpot({
    required this.id,
    required this.name,
    required this.emoji,
    required this.xPercent,
    required this.yPercent,
    required this.description,
    this.clueId,
    this.isExamined = false,
  });
}
