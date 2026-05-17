// lib/screens/dialogue_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../utils/app_theme.dart';
import '../services/game_provider.dart';
import '../services/sound_service.dart';
import '../models/game_models.dart';
import '../utils/app_strings.dart';

class DialogueScreen extends StatefulWidget {
  final Character character;
  final Chapter chapter;

  const DialogueScreen({
    super.key,
    required this.character,
    required this.chapter,
  });

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  List<DialogueBranch> _availableResponses = [];
  bool _isTyping = false;
  final Set<String> _usedDialogueIds = {};

  @override
  void initState() {
    super.initState();
    _initDialogue();
  }

  void _initDialogue() {
    // Opening message from character
    final openingMsg = _ChatMessage(
      text: AppStrings.get('dialogue_opening', context.read<GameProvider>().language),
      isPlayer: false,
      emoji: widget.character.emoji,
    );
    setState(() {
      _messages.add(openingMsg);
      _updateAvailableResponses();
    });
  }

  void _updateAvailableResponses() {
    final gameProvider = context.read<GameProvider>();
    _availableResponses = widget.character.dialogues
        .where((d) =>
            !_usedDialogueIds.contains(d.id) &&
            gameProvider.isDialogueAccessible(d))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildChatArea()),
            if (_availableResponses.isNotEmpty) _buildResponseOptions(),
            if (_availableResponses.isEmpty && !_isTyping) _buildEndOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bgSurface,
              border:
                  Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Text(widget.character.emoji,
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.character.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(widget.character.role,
                    style: GoogleFonts.notoSansDevanagari(
                        color: AppTheme.accent, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (_, i) {
        if (_isTyping && i == _messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessage(_messages[i], i);
      },
    );
  }

  Widget _buildMessage(_ChatMessage message, int index) {
    return Align(
      alignment:
          message.isPlayer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Row(
          mainAxisAlignment: message.isPlayer
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isPlayer) ...[
              Text(message.emoji ?? widget.character.emoji,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isPlayer
                      ? AppTheme.primary.withValues(alpha: 0.2)
                      : AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(12).copyWith(
                    bottomRight:
                        message.isPlayer ? const Radius.circular(0) : null,
                    bottomLeft:
                        !message.isPlayer ? const Radius.circular(0) : null,
                  ),
                  border: Border.all(
                    color: message.isPlayer
                        ? AppTheme.primary.withValues(alpha: 0.4)
                        : const Color(0xFF2A2A35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: GoogleFonts.notoSansDevanagari(
                        color: message.isPlayer
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    if (message.isClueRevealed) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppTheme.warning.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔍', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(AppStrings.get('new_clue', context.read<GameProvider>().language),
                                style: GoogleFonts.cinzel(
                                    color: AppTheme.warning, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (message.isPlayer) ...[
              const SizedBox(width: 8),
              const Text('🕵️', style: TextStyle(fontSize: 22)),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(widget.character.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(
                        begin: 0,
                        end: -4,
                        delay: Duration(milliseconds: 150 * i),
                        duration: 400.ms,
                      )
                      .then()
                      .moveY(begin: -4, end: 0, duration: 400.ms),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.get('what_to_ask', context.read<GameProvider>().language),
            style: GoogleFonts.cinzel(
                color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1),
          ),
          const SizedBox(height: 10),
          ..._availableResponses.take(3).map((dialogue) => _ResponseOption(
                dialogue: dialogue,
                onTap: () => _selectDialogue(dialogue),
              )),
        ],
      ),
    );
  }

  Widget _buildEndOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: Color(0xFF2A2A35))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.get('all_asked', context.read<GameProvider>().language),
            style: GoogleFonts.notoSansDevanagari(
                color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('back_to_investigation', context.read<GameProvider>().language)),
          ),
        ],
      ),
    );
  }

  void _selectDialogue(DialogueBranch dialogue) {
    SoundService().playButtonTap(); // 🔊 Dialogue select sound
    Vibration.vibrate(duration: 30);

    final gameProvider = context.read<GameProvider>();

    // Add player message
    setState(() {
      _messages.add(_ChatMessage(
        text: dialogue.trigger,
        isPlayer: true,
        emoji: '🕵️',
      ));
      _usedDialogueIds.add(dialogue.id);
      _isTyping = true;
      _availableResponses = [];
    });

    _scrollToBottom();

    // Simulate typing delay
    final delay = Duration(milliseconds: 800 + dialogue.response.length * 20);

    Future.delayed(delay, () {
      if (!mounted) return;

      gameProvider.triggerDialogue(widget.character.id, dialogue.id);

      final clueRevealed = dialogue.revealClue != null;

      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(
          text: dialogue.response,
          isPlayer: false,
          emoji: widget.character.emoji,
          isClueRevealed: clueRevealed,
        ));
        _updateAvailableResponses();
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// ─── Chat Message Model ───────────────────────────
class _ChatMessage {
  final String text;
  final bool isPlayer;
  final String? emoji;
  final bool isClueRevealed;

  _ChatMessage({
    required this.text,
    required this.isPlayer,
    this.emoji,
    this.isClueRevealed = false,
  });
}

// ─── Response Option Widget ───────────────────────
class _ResponseOption extends StatelessWidget {
  final DialogueBranch dialogue;
  final VoidCallback onTap;

  const _ResponseOption({required this.dialogue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: dialogue.isImportant == true
                ? AppTheme.primary.withValues(alpha: 0.5)
                : const Color(0xFF2A2A35),
          ),
        ),
        child: Row(
          children: [
            Text(
              dialogue.isImportant == true ? '🔑 ' : '💬 ',
              style: const TextStyle(fontSize: 14),
            ),
            Expanded(
              child: Text(
                dialogue.trigger,
                style: GoogleFonts.notoSansDevanagari(
                  color: dialogue.isImportant == true
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 12, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
