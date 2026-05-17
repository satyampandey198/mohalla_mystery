import 'package:translator/translator.dart';
import '../models/game_models.dart';

class TranslationService {
  static final _translator = GoogleTranslator();
  static final Map<String, Chapter> _chapterCache = {};
  static final Map<String, String> _stringCache = {};

  static Future<String> _t(String text) async {
    if (text.isEmpty) return text;
    if (_stringCache.containsKey(text)) return _stringCache[text]!;
    try {
      final translation = await _translator.translate(text, from: 'hi', to: 'en');
      _stringCache[text] = translation.text;
      return translation.text;
    } catch (e) {
      print("Translation error: $e");
      return text; // fallback to original
    }
  }

  static Future<Chapter> translateChapter(Chapter chapter) async {
    if (_chapterCache.containsKey(chapter.id)) {
      return _chapterCache[chapter.id]!;
    }

    final tTitle = await _t(chapter.title);
    final tSubtitle = await _t(chapter.subtitle);
    final tLocation = await _t(chapter.location);
    final tMystery = await _t(chapter.mystery);

    List<Clue> tClues = [];
    for (var c in chapter.clues) {
      tClues.add(Clue(
        id: c.id,
        name: await _t(c.name),
        description: await _t(c.description),
        emoji: c.emoji,
        location: await _t(c.location),
        isFound: c.isFound,
        isImportant: c.isImportant,
      ));
    }

    List<Character> tChars = [];
    for (var c in chapter.characters) {
      List<DialogueBranch> tDialogues = [];
      for (var d in c.dialogues) {
        tDialogues.add(DialogueBranch(
          id: d.id,
          trigger: await _t(d.trigger),
          response: await _t(d.response),
          revealClue: d.revealClue,
          isHidden: d.isHidden,
          requiredClueId: d.requiredClueId,
          followUpIds: d.followUpIds,
          isImportant: d.isImportant,
        ));
      }
      tChars.add(Character(
        id: c.id,
        name: await _t(c.name),
        role: await _t(c.role),
        emoji: c.emoji,
        description: await _t(c.description),
        dialogues: tDialogues,
        hasSpoken: c.hasSpoken,
        suspicionLevel: c.suspicionLevel,
      ));
    }

    List<InvestigationSpot> tSpots = [];
    for (var s in chapter.spots) {
      tSpots.add(InvestigationSpot(
        id: s.id,
        name: await _t(s.name),
        emoji: s.emoji,
        xPercent: s.xPercent,
        yPercent: s.yPercent,
        clueId: s.clueId,
        description: await _t(s.description),
        isExamined: s.isExamined,
      ));
    }

    final translatedChapter = Chapter(
      id: chapter.id,
      title: tTitle,
      subtitle: tSubtitle,
      location: tLocation,
      backgroundEmoji: chapter.backgroundEmoji,
      mystery: tMystery,
      solution: chapter.solution,
      isLocked: chapter.isLocked,
      clues: tClues,
      characters: tChars,
      spots: tSpots,
    );

    _chapterCache[chapter.id] = translatedChapter;
    return translatedChapter;
  }

  static Future<Chapter> translateChapterBasicInfo(Chapter chapter) async {
    final tTitle = await _t(chapter.title);
    final tSubtitle = await _t(chapter.subtitle);
    final tLocation = await _t(chapter.location);
    return chapter.copyWith(
      title: tTitle,
      subtitle: tSubtitle,
      location: tLocation,
    );
  }
}
