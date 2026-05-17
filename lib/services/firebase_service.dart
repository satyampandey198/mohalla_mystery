// lib/services/firebase_service.dart
// ============================================================
// Ye file Firestore se chapters fetch karti hai
// aur local cache bhi rakhti hai (offline support)
// ============================================================

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Cache Keys ──────────────────────────────────
  static const String _cacheKey = 'cached_chapters';
  static const String _cacheVersionKey = 'cached_version';

  // ============================================================
  // MAIN METHOD: Saare chapters fetch karo
  // ============================================================
  Future<List<Chapter>> fetchAllChapters() async {
    try {
      // 1. Pehle Firestore se try karo
      final chapters = await _fetchFromFirestore();
      
      // 2. Cache mein save karo (offline ke liye)
      await _saveToCache(chapters);
      
      return chapters;
    } catch (e) {
      print('Firestore error: $e — Cache se load kar rahe hain');
      
      // 3. Firestore fail ho toh cache use karo
      final cached = await _loadFromCache();
      if (cached.isNotEmpty) return cached;
      
      // 4. Cache bhi nahi hai toh local data
      print('Cache bhi empty — local data use kar rahe hain');
      return _getLocalFallbackData();
    }
  }

  // ============================================================
  // Firestore se fetch
  // ============================================================
  Future<List<Chapter>> _fetchFromFirestore() async {
    final chaptersSnap = await _db
        .collection('chapters')
        .orderBy('order')
        .get();

    final List<Chapter> chapters = [];

    for (final chapterDoc in chaptersSnap.docs) {
      final chapter = await _buildChapterFromDoc(chapterDoc);
      chapters.add(chapter);
    }

    return chapters;
  }

  Future<Chapter> _buildChapterFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> chapterDoc) async {
    final data = chapterDoc.data();

    // Sub-collections parallel fetch karo (fast!)
    final results = await Future.wait([
      chapterDoc.reference.collection('clues').orderBy('order').get(),
      chapterDoc.reference.collection('characters').get(),
      chapterDoc.reference.collection('spots').get(),
    ]);

    final cluesSnap = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final charsSnap = results[1] as QuerySnapshot<Map<String, dynamic>>;
    final spotsSnap = results[2] as QuerySnapshot<Map<String, dynamic>>;

    // Clues parse karo
    final clues = cluesSnap.docs.map((doc) {
      final d = doc.data();
      return Clue(
        id: d['id'] ?? doc.id,
        name: d['name'] ?? '',
        description: d['description'] ?? '',
        emoji: d['emoji'] ?? '🔍',
        location: d['location'] ?? '',
        isImportant: d['isImportant'] ?? false,
      );
    }).toList();

    // Characters parse karo
    final characters = charsSnap.docs.map((doc) {
      final d = doc.data();
      final dialoguesList = (d['dialogues'] as List<dynamic>? ?? []);
      
      final dialogues = dialoguesList.map((dl) {
        return DialogueBranch(
          id: dl['id'] ?? '',
          trigger: dl['trigger'] ?? '',
          response: dl['response'] ?? '',
          revealClue: dl['revealClue'],
          isHidden: dl['isHidden'] ?? false,
          requiredClueId: dl['requiredClueId'],
          isImportant: dl['isImportant'] ?? false,
          followUpIds: List<String>.from(dl['followUpIds'] ?? []),
        );
      }).toList();

      return Character(
        id: d['id'] ?? doc.id,
        name: d['name'] ?? '',
        role: d['role'] ?? '',
        emoji: d['emoji'] ?? '👤',
        description: d['description'] ?? '',
        suspicionLevel: d['suspicionLevel'] ?? 0,
        dialogues: dialogues,
      );
    }).toList();

    // Spots parse karo
    final spots = spotsSnap.docs.map((doc) {
      final d = doc.data();
      return InvestigationSpot(
        id: d['id'] ?? doc.id,
        name: d['name'] ?? '',
        emoji: d['emoji'] ?? '📍',
        xPercent: (d['xPercent'] ?? 0.5).toDouble(),
        yPercent: (d['yPercent'] ?? 0.5).toDouble(),
        clueId: d['clueId'],
        description: d['description'] ?? '',
      );
    }).toList();

    return Chapter(
      id: data['id'] ?? chapterDoc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      location: data['location'] ?? '',
      backgroundEmoji: data['backgroundEmoji'] ?? '🏚️',
      mystery: data['mystery'] ?? '',
      solution: data['solution'] ?? '',
      isLocked: data['isLocked'] ?? false,
      clues: clues,
      characters: characters,
      spots: spots,
    );
  }

  // ============================================================
  // Single chapter refresh (jab update aaye)
  // ============================================================
  Future<Chapter?> refreshChapter(String chapterId) async {
    try {
      final doc = await _db.collection('chapters').doc(chapterId).get();
      if (!doc.exists) return null;
      
      final cluesSnap = await doc.reference.collection('clues').orderBy('order').get();
      final charsSnap = await doc.reference.collection('characters').get();
      final spotsSnap = await doc.reference.collection('spots').get();

      final data = doc.data()!;

      final clues = cluesSnap.docs.map((d) => Clue(
        id: d['id'] ?? d.id,
        name: d['name'] ?? '',
        description: d['description'] ?? '',
        emoji: d['emoji'] ?? '🔍',
        location: d['location'] ?? '',
        isImportant: d['isImportant'] ?? false,
      )).toList();

      final characters = charsSnap.docs.map((d) {
        final dialogues = (d['dialogues'] as List? ?? []).map((dl) => DialogueBranch(
          id: dl['id'] ?? '', trigger: dl['trigger'] ?? '', response: dl['response'] ?? '',
          revealClue: dl['revealClue'], isHidden: dl['isHidden'] ?? false,
          requiredClueId: dl['requiredClueId'], isImportant: dl['isImportant'] ?? false,
        )).toList();
        return Character(
          id: d['id'] ?? d.id, name: d['name'] ?? '', role: d['role'] ?? '',
          emoji: d['emoji'] ?? '👤', description: d['description'] ?? '',
          suspicionLevel: d['suspicionLevel'] ?? 0, dialogues: dialogues,
        );
      }).toList();

      final spots = spotsSnap.docs.map((d) => InvestigationSpot(
        id: d['id'] ?? d.id, name: d['name'] ?? '', emoji: d['emoji'] ?? '📍',
        xPercent: (d['xPercent'] ?? 0.5).toDouble(),
        yPercent: (d['yPercent'] ?? 0.5).toDouble(),
        clueId: d['clueId'], description: d['description'] ?? '',
      )).toList();

      return Chapter(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '', subtitle: data['subtitle'] ?? '',
        location: data['location'] ?? '', backgroundEmoji: data['backgroundEmoji'] ?? '🏚️',
        mystery: data['mystery'] ?? '', solution: data['solution'] ?? '',
        isLocked: data['isLocked'] ?? false,
        clues: clues, characters: characters, spots: spots,
      );
    } catch (e) {
      print('Chapter refresh error: $e');
      return null;
    }
  }

  // ============================================================
  // Real-time listener — jab Firestore mein update ho toh auto-refresh
  // ============================================================
  Stream<List<Chapter>> chaptersStream() {
    return _db
        .collection('chapters')
        .orderBy('order')
        .snapshots()
        .asyncMap((snapshot) async {
      final List<Chapter> chapters = [];
      for (final doc in snapshot.docs) {
        final chapter = await _buildChapterFromDoc(doc);
        chapters.add(chapter);
      }
      return chapters;
    });
  }

  // ============================================================
  // App Config fetch (version check, new chapter announcement)
  // ============================================================
  Future<Map<String, dynamic>> fetchAppConfig() async {
    try {
      final doc = await _db.collection('config').doc('app_config').get();
      return doc.data() ?? {};
    } catch (e) {
      return {};
    }
  }

  // ============================================================
  // Cache System (Offline Support)
  // ============================================================
  Future<void> _saveToCache(List<Chapter> chapters) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = chapters.map((c) => _chapterToJson(c)).toList();
      await prefs.setString(_cacheKey, jsonEncode(jsonList));
      await prefs.setInt(_cacheVersionKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Cache save error: $e');
    }
  }

  Future<List<Chapter>> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached == null) return [];

      final jsonList = jsonDecode(cached) as List;
      return jsonList.map((j) => _chapterFromJson(j)).toList();
    } catch (e) {
      print('Cache load error: $e');
      return [];
    }
  }

  // ─── JSON Serialization ───────────────────────────
  Map<String, dynamic> _chapterToJson(Chapter c) => {
    'id': c.id, 'title': c.title, 'subtitle': c.subtitle,
    'location': c.location, 'backgroundEmoji': c.backgroundEmoji,
    'mystery': c.mystery, 'solution': c.solution, 'isLocked': c.isLocked,
    'clues': c.clues.map((cl) => {
      'id': cl.id, 'name': cl.name, 'description': cl.description,
      'emoji': cl.emoji, 'location': cl.location, 'isImportant': cl.isImportant,
    }).toList(),
    'characters': c.characters.map((ch) => {
      'id': ch.id, 'name': ch.name, 'role': ch.role, 'emoji': ch.emoji,
      'description': ch.description, 'suspicionLevel': ch.suspicionLevel,
      'dialogues': ch.dialogues.map((d) => {
        'id': d.id, 'trigger': d.trigger, 'response': d.response,
        'revealClue': d.revealClue, 'isHidden': d.isHidden,
        'requiredClueId': d.requiredClueId, 'isImportant': d.isImportant,
        'followUpIds': d.followUpIds,
      }).toList(),
    }).toList(),
    'spots': c.spots.map((s) => {
      'id': s.id, 'name': s.name, 'emoji': s.emoji,
      'xPercent': s.xPercent, 'yPercent': s.yPercent,
      'clueId': s.clueId, 'description': s.description,
    }).toList(),
  };

  Chapter _chapterFromJson(Map<String, dynamic> j) => Chapter(
    id: j['id'] ?? '', title: j['title'] ?? '', subtitle: j['subtitle'] ?? '',
    location: j['location'] ?? '', backgroundEmoji: j['backgroundEmoji'] ?? '🏚️',
    mystery: j['mystery'] ?? '', solution: j['solution'] ?? '',
    isLocked: j['isLocked'] ?? false,
    clues: (j['clues'] as List? ?? []).map((c) => Clue(
      id: c['id'] ?? '', name: c['name'] ?? '', description: c['description'] ?? '',
      emoji: c['emoji'] ?? '🔍', location: c['location'] ?? '',
      isImportant: c['isImportant'] ?? false,
    )).toList(),
    characters: (j['characters'] as List? ?? []).map((c) => Character(
      id: c['id'] ?? '', name: c['name'] ?? '', role: c['role'] ?? '',
      emoji: c['emoji'] ?? '👤', description: c['description'] ?? '',
      suspicionLevel: c['suspicionLevel'] ?? 0,
      dialogues: (c['dialogues'] as List? ?? []).map((d) => DialogueBranch(
        id: d['id'] ?? '', trigger: d['trigger'] ?? '', response: d['response'] ?? '',
        revealClue: d['revealClue'], isHidden: d['isHidden'] ?? false,
        requiredClueId: d['requiredClueId'], isImportant: d['isImportant'] ?? false,
      )).toList(),
    )).toList(),
    spots: (j['spots'] as List? ?? []).map((s) => InvestigationSpot(
      id: s['id'] ?? '', name: s['name'] ?? '', emoji: s['emoji'] ?? '📍',
      xPercent: (s['xPercent'] ?? 0.5).toDouble(),
      yPercent: (s['yPercent'] ?? 0.5).toDouble(),
      clueId: s['clueId'], description: s['description'] ?? '',
    )).toList(),
  );

  // Local fallback (agar kuch bhi na ho)
  List<Chapter> _getLocalFallbackData() {
    return [];
  }
}
