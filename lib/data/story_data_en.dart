// lib/data/story_data_en.dart

import '../models/game_models.dart';

class StoryDataEn {
  static List<Chapter> getAllChapters() {
    return [
      chapter1(),
      chapter2(),
      chapter3(),
    ];
  }

  static Chapter chapter1() {
    return Chapter(
      id: 'chapter_1',
      title: 'Neem Wali Haveli',
      subtitle: 'A secret hidden for 40 years...',
      location: 'Old Delhi — Gulshan Nagar',
      backgroundEmoji: '🏚️',
      mystery:
          'A strange noise was heard tonight from the old haveli in Gulshan Nagar. Neighbor Ramesh Uncle was found dead inside — but the door was locked from the inside. How did the killer escape? And why? You have 1 hour to solve this mystery...',
      clues: [
        Clue(
          id: 'clue_1_footprints',
          name: 'Footprints',
          description:
              'Footprints in the mud under the Neem tree. They belong to a human — but they lead towards the back wall, not the door.',
          emoji: '👣',
          location: 'Neem Tree',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_letter',
          name: 'Forged Letter',
          description:
              'An old letter — "Ramesh, you will finally pay for what you did 40 years ago. — An Enemy"',
          emoji: '📜',
          location: 'Haveli Room',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_key',
          name: 'Broken Lock',
          description:
              'The back door lock was broken from the outside, not the inside. Meaning someone went in — and then locked it from the outside upon leaving.',
          emoji: '🔑',
          location: 'Back Door',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_photo',
          name: 'Old Photograph',
          description:
              'A group photo from 1983. It shows Ramesh Uncle with 4 others. Written on the back: "Only we know the burden of this land."',
          emoji: '📷',
          location: 'Behind the Cupboard',
          isImportant: false,
        ),
        Clue(
          id: 'clue_1_medicine',
          name: 'Medicine Bottle',
          description:
              'An empty medicine bottle — the label says "Sleeping Pills — 10x dose is lethally dangerous".',
          emoji: '💊',
          location: 'Kitchen',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_sunita_bai',
          name: 'Sunita Bai',
          role: 'Housemaid',
          emoji: '👩‍🦳',
          description: 'Has worked at the Haveli for 20 years. Her eyes look terrified.',
          suspicionLevel: 30,
          dialogues: [
            DialogueBranch(
              id: 'd1_sunita_1',
              trigger: 'What happened today?',
              response:
                  'Sir... I came in the morning to sweep. The door was locked from the inside. I called out, but no answer. Then the neighbor called the police...',
              followUpIds: ['d1_sunita_2', 'd1_sunita_3'],
            ),
            DialogueBranch(
              id: 'd1_sunita_2',
              trigger: 'Did you hear anything at night?',
              response:
                  'Yes... around 2 AM... the sound of a window opening. I was half-asleep, but I remember. Then faint sounds... like footsteps...',
              followUpIds: ['d1_sunita_4'],
            ),
            DialogueBranch(
              id: 'd1_sunita_3',
              trigger: 'Ramesh Uncle\'s enemies?',
              response:
                  'He was a very good man... yes, someone came a few years ago. I remember they argued aggressively. For a long time...',
              followUpIds: ['d1_sunita_5'],
            ),
            DialogueBranch(
              id: 'd1_sunita_4',
              trigger: 'Footsteps? Who was it?',
              response:
                  'I can\'t say for sure... but he once mentioned he had a brother... who would visit sometimes at night. And they would argue...',
              isImportant: true,
              revealClue: 'clue_1_photo',
            ),
            DialogueBranch(
              id: 'd1_sunita_5',
              trigger: 'What did that man look like?',
              response:
                  'Around 60-65 years old. Looked a lot like Uncle... yes! Very similar! And he came from the back — through the neem tree path!',
              isImportant: true,
              requiredClueId: 'clue_1_footprints',
            ),
          ],
        ),
        Character(
          id: 'char_dinesh',
          name: 'Dinesh Sharma',
          role: 'Neighbor',
          emoji: '👴',
          description: 'Lives right opposite. Keeps an eye on everything.',
          suspicionLevel: 20,
          dialogues: [
            DialogueBranch(
              id: 'd1_dinesh_1',
              trigger: 'Did you see anything?',
              response:
                  'Yes brother! A man was standing under the neem tree at night. I thought someone came for a stroll. It was too dark to see his face.',
              followUpIds: ['d1_dinesh_2'],
            ),
            DialogueBranch(
              id: 'd1_dinesh_2',
              trigger: 'What time was it?',
              response:
                  'Around 1:30 or 2 AM. I couldn\'t sleep so I was standing at my door. That man went towards the back — near the wall.',
              revealClue: 'clue_1_footprints',
              isImportant: true,
            ),
          ],
        ),
        Character(
          id: 'char_inspector',
          name: 'Inspector Mishra',
          role: 'Police Inspector',
          emoji: '👮',
          description: 'Looks tired, drinking tea. Claims it\'s a natural death.',
          suspicionLevel: 0,
          dialogues: [
            DialogueBranch(
              id: 'd1_insp_1',
              trigger: 'Is this a murder?',
              response:
                  'Look brother, the door was locked from the inside. How could anyone get in? Looks like a natural death. Probably overdosed on sleeping pills...',
              followUpIds: ['d1_insp_2'],
            ),
            DialogueBranch(
              id: 'd1_insp_2',
              trigger: 'What about the back door lock?',
              response:
                  'What...? Back door...? We only checked the front. If the lock was actually broken... then this is a different case altogether.',
              requiredClueId: 'clue_1_key',
              isImportant: true,
              revealClue: 'clue_1_letter',
            ),
          ],
        ),
        Character(
          id: 'char_vikram',
          name: 'Vikram — "The Brother"',
          role: 'Ramesh\'s brother (Suspect)',
          emoji: '🕵️',
          description:
              'You spot him from afar. He is hiding in the neighborhood alleys. Looks extremely nervous.',
          suspicionLevel: 85,
          dialogues: [
            DialogueBranch(
              id: 'd1_vikram_1',
              trigger: 'What are you doing here?',
              response:
                  'I... I came after hearing the news about my brother. I felt awful. We had our differences... but blood is blood...',
              followUpIds: ['d1_vikram_2', 'd1_vikram_3'],
            ),
            DialogueBranch(
              id: 'd1_vikram_2',
              trigger: 'Did you go to the haveli last night?',
              response:
                  'No! I was... I was at my house. No witnesses either... I live alone. But I didn\'t go there!',
              isImportant: true,
            ),
            DialogueBranch(
              id: 'd1_vikram_3',
              trigger: 'Did you write this letter?',
              response:
                  '(Hands start trembling) That letter... where did you find it? I... 40 years ago Ramesh seized my land. My mother\'s land! But I... I didn\'t do anything...',
              requiredClueId: 'clue_1_letter',
              isImportant: true,
            ),
          ],
        ),
      ],
      solution: 'char_vikram',
    );
  }

  static Chapter chapter2() {
    return Chapter(
      id: 'chapter_2',
      title: 'The Graveyard Gate',
      subtitle: 'A living secret in the city of wishes...',
      location: 'Lucknow — Chaand Bagh',
      backgroundEmoji: '⚰️',
      mystery:
          'A bright light was seen in the old Chaand Bagh graveyard at night. The watchman Hafeez was found dead inside an open grave — but with no visible injuries. Are ghosts real? Or is it something else?',
      clues: [
        Clue(
          id: 'clue_2_matches',
          name: 'Scattered Matches',
          description: 'Matchsticks scattered near the grave. Someone lit a fire at night.',
          emoji: '🔥',
          location: 'Graveyard Gate',
          isImportant: true,
        ),
        Clue(
          id: 'clue_2_gold',
          name: 'Gold in the Dirt',
          description: 'Old gold coins buried within the grave\'s soil.',
          emoji: '💰',
          location: 'The Grave',
          isImportant: true,
        ),
        Clue(
          id: 'clue_2_amulet',
          name: 'Broken Amulet',
          description: 'Hafeez\'s amulet lies broken. It was pulled forcefully.',
          emoji: '📿',
          location: 'Old Hut',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_moulvi',
          name: 'Moulvi Sahab',
          role: 'Cleric',
          emoji: '👳',
          description: 'Lives near the shrine. Believes strongly in spirits and ghosts.',
          suspicionLevel: 10,
          dialogues: [
            DialogueBranch(
              id: 'd2_moulvi_1',
              trigger: 'How did Hafeez die?',
              response: 'It\'s the curse of the Jinn! Strange voices came from that grave at night. Hafeez went there alone...',
              followUpIds: ['d2_moulvi_2'],
            ),
            DialogueBranch(
              id: 'd2_moulvi_2',
              trigger: 'Did you see the light?',
              response: 'Yes, it was the flicker of matchsticks. Perhaps someone was performing black magic.',
              revealClue: 'clue_2_matches',
              isImportant: true,
            ),
          ],
        ),
        Character(
          id: 'char_rizwan',
          name: 'Rizwan',
          role: 'Gravedigger (Suspect)',
          emoji: '⛏️',
          description: 'Works at the graveyard. Appears slightly panicked.',
          suspicionLevel: 80,
          dialogues: [
            DialogueBranch(
              id: 'd2_rizwan_1',
              trigger: 'Where were you last night?',
              response: 'I was sleeping! I have nothing to do with that grave.',
              followUpIds: ['d2_rizwan_2'],
            ),
            DialogueBranch(
              id: 'd2_rizwan_2',
              trigger: 'Whose gold coins are these?',
              response: 'Gold?! I don\'t know... Hafeez saw me digging the dirt there... but I wasn\'t stealing!',
              requiredClueId: 'clue_2_gold',
              isImportant: true,
            ),
            DialogueBranch(
              id: 'd2_rizwan_3',
              trigger: 'So you attacked him?',
              response: 'No! He grabbed my amulet and I panicked... he slipped and hit his head on a stone!',
              requiredClueId: 'clue_2_amulet',
              isImportant: true,
            ),
          ],
        ),
      ],
      solution: 'char_rizwan',
      isLocked: true,
    );
  }

  static Chapter chapter3() {
    return Chapter(
      id: 'chapter_3',
      title: 'Night of the Well',
      subtitle: 'The village well that screams at night...',
      location: 'Rajasthan — Bhootgarh Village',
      backgroundEmoji: '🌑',
      mystery:
          'Voices echo from the old well in Bhootgarh at night. The villagers claim it\'s haunted. One day, a stranger\'s body is found near the well. No blood trails, just a long piece of rope.',
      clues: [
        Clue(
          id: 'clue_3_rope',
          name: 'Wet Rope',
          description: 'The well\'s rope is half-wet and stretched taut.',
          emoji: '🪢',
          location: 'The Well',
          isImportant: true,
        ),
        Clue(
          id: 'clue_3_cloth',
          name: 'Torn Cloth',
          description: 'A piece of torn red cloth is tangled near the rope.',
          emoji: '🧣',
          location: 'Banyan Tree',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_sarpanch',
          name: 'Sarpanch',
          role: 'Village Head',
          emoji: '👨‍🌾',
          description: 'An authoritative man, but seems frightened of something.',
          suspicionLevel: 40,
          dialogues: [
            DialogueBranch(
              id: 'd3_sarpanch_1',
              trigger: 'What happened near the well?',
              response: 'That well is cursed! No one goes near it.',
              followUpIds: ['d3_sarpanch_2'],
            ),
            DialogueBranch(
              id: 'd3_sarpanch_2',
              trigger: 'Whose red cloth is this?',
              response: 'This looks like Meera\'s... what was she doing there at night?',
              requiredClueId: 'clue_3_cloth',
              isImportant: true,
            ),
          ],
        ),
        Character(
          id: 'char_meera',
          name: 'Meera',
          role: 'Village Girl (Suspect)',
          emoji: '🧕',
          description: 'Wanders alone, scared of everyone.',
          suspicionLevel: 90,
          dialogues: [
            DialogueBranch(
              id: 'd3_meera_1',
              trigger: 'Who was the stranger?',
              response: 'I don\'t know... I wasn\'t there.',
              followUpIds: ['d3_meera_2'],
            ),
            DialogueBranch(
              id: 'd3_meera_2',
              trigger: 'Why did you pull the rope?',
              response: 'He threatened me! I had to push him into the well to save myself...',
              requiredClueId: 'clue_3_rope',
              isImportant: true,
            ),
          ],
        ),
      ],
      solution: 'char_meera',
      isLocked: true,
    );
  }

  static List<InvestigationSpot> getChapter1Spots() {
    return [
      InvestigationSpot(
        id: 'spot_neem',
        name: 'Neem Tree 🌳',
        emoji: '🌳',
        xPercent: 0.15,
        yPercent: 0.35,
        clueId: 'clue_1_footprints',
        description: 'The old neem tree — even the wind feels still near it.',
      ),
      InvestigationSpot(
        id: 'spot_darwaza',
        name: 'Back Door 🚪',
        emoji: '🚪',
        xPercent: 0.75,
        yPercent: 0.55,
        clueId: 'clue_1_key',
        description: 'The back door of the haveli — rusted but shows fresh marks.',
      ),
      InvestigationSpot(
        id: 'spot_kamra',
        name: 'Main Room 🛋️',
        emoji: '🛋️',
        xPercent: 0.45,
        yPercent: 0.4,
        clueId: 'clue_1_letter',
        description: 'The room where Ramesh Uncle was found dead. Old furniture, dim light.',
      ),
      InvestigationSpot(
        id: 'spot_almari',
        name: 'Old Cupboard 🗄️',
        emoji: '🗄️',
        xPercent: 0.62,
        yPercent: 0.3,
        clueId: 'clue_1_photo',
        description: 'A stuffed cupboard — clothes, documents, and maybe secrets.',
      ),
      InvestigationSpot(
        id: 'spot_kitchen',
        name: 'Kitchen 🍳',
        emoji: '🍳',
        xPercent: 0.28,
        yPercent: 0.65,
        clueId: 'clue_1_medicine',
        description: 'A small kitchen — the ashes have gone cold.',
      ),
    ];
  }

  static List<InvestigationSpot> getChapter2Spots() {
    return [
      InvestigationSpot(
        id: 'spot_qabr',
        name: 'Old Grave ⚰️',
        emoji: '⚰️',
        xPercent: 0.5,
        yPercent: 0.6,
        clueId: 'clue_2_gold',
        description: 'Hafeez\'s body was found here. The dirt is freshly dug.',
      ),
      InvestigationSpot(
        id: 'spot_gate',
        name: 'Graveyard Gate 🚪',
        emoji: '🚪',
        xPercent: 0.2,
        yPercent: 0.3,
        clueId: 'clue_2_matches',
        description: 'Light was seen here during the night.',
      ),
      InvestigationSpot(
        id: 'spot_hut',
        name: 'Watchman\'s Hut 🏚️',
        emoji: '🏚️',
        xPercent: 0.7,
        yPercent: 0.4,
        clueId: 'clue_2_amulet',
        description: 'Hafeez used to sleep here. Things are scattered.',
      ),
    ];
  }

  static List<InvestigationSpot> getChapter3Spots() {
    return [
      InvestigationSpot(
        id: 'spot_kuan',
        name: 'Bhootgarh Well 🕳️',
        emoji: '🕳️',
        xPercent: 0.45,
        yPercent: 0.5,
        clueId: 'clue_3_rope',
        description: 'An extremely old well, dark and silent inside.',
      ),
      InvestigationSpot(
        id: 'spot_banyan',
        name: 'Banyan Tree 🌳',
        emoji: '🌳',
        xPercent: 0.2,
        yPercent: 0.3,
        clueId: 'clue_3_cloth',
        description: 'Something is tangled on the tree branch.',
      ),
      InvestigationSpot(
        id: 'spot_fields',
        name: 'Fields 🌾',
        emoji: '🌾',
        xPercent: 0.75,
        yPercent: 0.6,
        clueId: null,
        description: 'Dry fields, nothing was found here.',
      ),
    ];
  }

  static List<InvestigationSpot> getSpotsForChapter(String chapterId) {
    if (chapterId == 'chapter_1') return getChapter1Spots();
    if (chapterId == 'chapter_2') return getChapter2Spots();
    if (chapterId == 'chapter_3') return getChapter3Spots();
    return [];
  }
}
