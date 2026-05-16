// lib/utils/app_strings.dart

class AppStrings {
  static const Map<String, Map<String, String>> localized = {
    'hindi': {
      // Main Menu
      'game_title': 'MOHALLA MYSTERY',
      'game_subtitle': 'मोहल्ले का रहस्य',
      'tagline': 'DESI HORROR PUZZLE',
      'btn_start': 'KHEL SHURU KARO',
      'btn_start_sub': 'नया रहस्य सुलझाओ',
      'btn_hints': 'HINTS',
      'btn_language': 'BHASHA',
      'btn_how_to_play': 'HOW TO PLAY',
      'btn_how_to_play_sub': 'Kaise khelen?',
      'stats_chapters': 'Chapters Solved',
      'stats_score': 'Total Score',
      
      // Chapter Select
      'chapter_title': 'MOHALLA CHUNIYE',
      'chapter_subtitle': 'Kaunsa raaz sulajhana hai?',
      'chapter_solved': 'SOLVED',
      'chapter_locked_msg': 'Pehle wala chapter complete karo!',
      'coming_soon_title': 'Aur chapters aa rahe hain!',
      'coming_soon_sub': 'Chapter 4: "Pahadon ka Saaya" — Coming Soon',

      // Investigation Screen
      'tab_story': '📖 STORY',
      'tab_map': '🗺️ JAGAH',
      'tab_suspects': '👥 SUSPECTS',
      'tab_notes': '📝 NOTES',
      'mystery_brief_title': '⚠️ MAMLA KYA HAI?',
      'mystery_brief_desc': 'JAGAH tab mein spots dhundo, SUSPECTS se baat karo, NOTES mein clues dekho aur mujrim pakdo!',
      'investigation_area': 'INVESTIGATION AREA',
      'btn_accuse': 'ILZAAM LAGAO',
      'clues_found_enough': 'Kafi clues mil gaye! Suspect pakdo!',
      'clues_needed': 'aur clues dhundho',
      'clues_needed_snackbar': 'Abhi aur clues chahiye!',
      'spot_examined': 'Yeh jagah pehle hi dekh li:',
      'nothing_found': 'Yahan kuch khaas nahi mila.',
      'btn_continue': 'AAGE BADO',
      
      // Notes
      'notes_title': 'DETECTIVE KE NOTES',
      'notes_empty': 'Abhi koi clue nahi mila.\nJagahon ko dhyan se dekho!',
      
      // Dialogues/Hints
      'hint_title': 'Detective ka Hint',
      'hint_remaining': 'hints baaki hain',
      'btn_thanks': 'SHUKRIYA!',
      'hint_empty_title': 'Hints Khatam!',
      'hint_empty_desc': 'Ad dekho aur 3 hints pao!',
      'btn_watch_ad': 'VIDEO DEKHO — 3 HINTS PAO',
      'btn_cancel': 'CANCEL',
      'dialogue_opening': 'Arey! Tum inspector ho? ...Theek hai, puchho jo puchna ho. Lekin main zyada nahi jaanta.',
      'suspicion': 'SUSPICION',
      'new_clue': 'Naya Clue Mila!',
      'what_to_ask': 'Kya puchoge?',
      'all_asked': 'Sab puch liya.',
      'back_to_investigation': 'INVESTIGATION WAPAS',
      
      // Accusation
      'think_carefully': 'Soch Samajhkar!',
      'accuse_warning': 'Galat ilzaam lagaya toh score minus hoga. Apne clues dobara dekho.',
      'who_is_guilty': 'Kaun hai qusoorwar?',
      'choose_suspect': 'Ek suspect chuniye',
      'this_is_culprit': 'YEH HAI MUJRIM!',
      'choose_suspect_btn': 'SUSPECT CHUNIYE',
      'correct_guess': 'SAHI PAKDA!',
      'wrong_guess': 'GALAT GUESS!',
      'is_culprit': 'hi asli mujrim tha!',
      'is_not_culprit': 'qusoorwar nahi hai. Aur clues dhundho!',
      'mystery_solved_btn': 'MYSTERY SOLVED! 🎉',
      'go_back': 'WAPAS JAO',
      
      // Clues overlay
      'clue_found': '🔍 CLUE MILA!',
      'clue_revisit': '🔍 CLUE DOBARA DEKHO',

      // General
      'suspect': 'SUSPECT',
      'watch': 'WATCH',
      'clear': 'CLEAR',
    },
    'english': {
      // Main Menu
      'game_title': 'MOHALLA MYSTERY',
      'game_subtitle': 'Mystery of the Neighborhood',
      'tagline': 'DESI HORROR PUZZLE',
      'btn_start': 'START GAME',
      'btn_start_sub': 'Solve a new mystery',
      'btn_hints': 'HINTS',
      'btn_language': 'LANGUAGE',
      'btn_how_to_play': 'HOW TO PLAY',
      'btn_how_to_play_sub': 'Rules & Guide',
      'stats_chapters': 'Chapters Solved',
      'stats_score': 'Total Score',
      
      // Chapter Select
      'chapter_title': 'SELECT NEIGHBORHOOD',
      'chapter_subtitle': 'Which mystery will you solve?',
      'chapter_solved': 'SOLVED',
      'chapter_locked_msg': 'Complete the previous chapter first!',
      'coming_soon_title': 'More chapters coming soon!',
      'coming_soon_sub': 'Chapter 4: "Shadow of the Hills" — Coming Soon',

      // Investigation Screen
      'tab_story': '📖 STORY',
      'tab_map': '🗺️ MAP',
      'tab_suspects': '👥 SUSPECTS',
      'tab_notes': '📝 NOTES',
      'mystery_brief_title': '⚠️ WHAT IS THE CASE?',
      'mystery_brief_desc': 'Find spots in the MAP tab, talk to SUSPECTS, check clues in NOTES, and catch the killer!',
      'investigation_area': 'INVESTIGATION AREA',
      'btn_accuse': 'MAKE ACCUSATION',
      'clues_found_enough': 'Enough clues found! Catch the suspect!',
      'clues_needed': 'more clues needed',
      'clues_needed_snackbar': 'More clues needed right now!',
      'spot_examined': 'You already checked this place:',
      'nothing_found': 'Nothing special found here.',
      'btn_continue': 'CONTINUE',
      
      // Notes
      'notes_title': 'DETECTIVE NOTES',
      'notes_empty': 'No clues found yet.\nLook closely at the locations!',
      
      // Dialogues/Hints
      'hint_title': 'Detective\'s Hint',
      'hint_remaining': 'hints remaining',
      'btn_thanks': 'THANKS!',
      'hint_empty_title': 'Out of Hints!',
      'hint_empty_desc': 'Watch an ad to get 3 hints!',
      'btn_watch_ad': 'WATCH AD — GET 3 HINTS',
      'btn_cancel': 'CANCEL',
      'dialogue_opening': 'Hey! Are you the inspector? ...Alright, ask what you want. But I don\'t know much.',
      'suspicion': 'SUSPICION',
      'new_clue': 'New Clue Found!',
      'what_to_ask': 'What will you ask?',
      'all_asked': 'Asked everything.',
      'back_to_investigation': 'BACK TO INVESTIGATION',
      
      // Accusation
      'think_carefully': 'Think Carefully!',
      'accuse_warning': 'Wrong accusation will reduce your score. Review your clues.',
      'who_is_guilty': 'Who is the culprit?',
      'choose_suspect': 'Choose a suspect',
      'this_is_culprit': 'THIS IS THE CULPRIT!',
      'choose_suspect_btn': 'CHOOSE A SUSPECT',
      'correct_guess': 'CORRECT GUESS!',
      'wrong_guess': 'WRONG GUESS!',
      'is_culprit': 'was the real culprit!',
      'is_not_culprit': 'is not the culprit. Find more clues!',
      'mystery_solved_btn': 'MYSTERY SOLVED! 🎉',
      'go_back': 'GO BACK',
      
      // Clues overlay
      'clue_found': '🔍 CLUE FOUND!',
      'clue_revisit': '🔍 REVIEW CLUE',

      // General
      'suspect': 'SUSPECT',
      'watch': 'WATCH',
      'clear': 'CLEAR',
    }
  };

  static String get(String key, String language) {
    return localized[language]?[key] ?? localized['hindi']?[key] ?? key;
  }
}
