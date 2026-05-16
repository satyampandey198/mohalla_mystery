// lib/data/story_data.dart

import '../models/game_models.dart';
import 'story_data_en.dart';

class StoryData {
  static List<Chapter> getAllChapters(String lang) {
    if (lang == 'english') return StoryDataEn.getAllChapters();
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
      subtitle: 'Raaz jo 40 saal se chhupta raha...',
      location: 'Purani Dilli — Mohalla Gulshan Nagar',
      backgroundEmoji: '🏚️',
      mystery:
          'Gulshan Nagar ki purani haveli me aaj raat ek ajeeb awaaz aayi. Padosi Ramesh Chacha ki laash haveli ke andar mili — lekin darwaza andar se band tha. Koi wahan se kaise nikla? Aur kyun? Tumhe 1 ghante me ye raaz sulajhana hai...',
      clues: [
        Clue(
          id: 'clue_1_footprints',
          name: 'Paon ke Nishan',
          description:
              'Neem ke neeche mitti me paon ke nishan hain. Ek insaan ke — lekin woh seedhe darwaze ki taraf nahi, peeche dewar ki taraf gaye hain.',
          emoji: '👣',
          location: 'Neem Ka Ped',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_letter',
          name: 'Jaali Chithi',
          description:
              'Ek purani chithi — "Ramesh, tumne jo 40 saal pehle kiya tha, uski saza ab milegi. — Ek dushman"',
          emoji: '📜',
          location: 'Haveli ka Kamra',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_key',
          name: 'Tuta Hua Taala',
          description:
              'Peechle darwaze ka taala andar se nahi, bahar se toda gaya hai. Matlab koi andar gaya — aur phir bahar se band karke chala gaya.',
          emoji: '🔑',
          location: 'Peechla Darwaza',
          isImportant: true,
        ),
        Clue(
          id: 'clue_1_photo',
          name: 'Purani Tasveer',
          description:
              'Ek group photo — 1983 ki. Ismein Ramesh Chacha ke saath 4 aur log hain. Peechhe likha hai: "Zameen ka bojh sirf hum jaante hain."',
          emoji: '📷',
          location: 'Almari ke Peeche',
          isImportant: false,
        ),
        Clue(
          id: 'clue_1_medicine',
          name: 'Dawai ki Sheesha',
          description:
              'Ek khali dawai ki bottle — label par likha hai "Neend ki Dawai — 10 guna zyada dose lethally dangerous".',
          emoji: '💊',
          location: 'Bawarchi Khana',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_sunita_bai',
          name: 'Sunita Bai',
          role: 'Kaam Wali Bai',
          emoji: '👩‍🦳',
          description: 'Haveli me 20 saal se kaam karti hai. Ankhein sehmi hui hain.',
          suspicionLevel: 30,
          dialogues: [
            DialogueBranch(
              id: 'd1_sunita_1',
              trigger: 'Aaj kya hua?',
              response:
                  'Ji... main subah aayi thi jhaadu lagane. Darwaza andar se band tha. Maine awaz di, koi jawab nahi aaya. Phir pados wale ne police bulai...',
              followUpIds: ['d1_sunita_2', 'd1_sunita_3'],
            ),
            DialogueBranch(
              id: 'd1_sunita_2',
              trigger: 'Raat ko kuch sunai diya?',
              response:
                  'Haan... raat ko kareeb 2 baje... ek khidki khulne ki awaaz. Main neend mein thi, lekin yaad hai. Phir koi halki si awaaz... jaise kadam...',
              followUpIds: ['d1_sunita_4'],
            ),
            DialogueBranch(
              id: 'd1_sunita_3',
              trigger: 'Ramesh Chacha ke dushman?',
              response:
                  'Woh toh bohot acche insaan the... haan, ek baar kuch saal pehle koi aaya tha. Mujhe yaad hai unhone bohot gusse mein baat ki. Kaafi dair tak...',
              followUpIds: ['d1_sunita_5'],
            ),
            DialogueBranch(
              id: 'd1_sunita_4',
              trigger: 'Kadam? Kaun tha?',
              response:
                  'Main pakke se nahi keh sakti... lekin ek baar inhone bataya tha ki unka ek bhai hai... jo kabhi kabhi raat ko aata tha. Aur dono mein kabhi kabhi jhagda hota tha...',
              isImportant: true,
              revealClue: 'clue_1_photo',
            ),
            DialogueBranch(
              id: 'd1_sunita_5',
              trigger: 'Woh aadmi kaisa tha?',
              response:
                  'Yahi kareeb 60-65 saal ke the. Chacha jaisi hi shakal... haan! Bilkul milti julti! Aur peechhe ki taraf se aaye the — neem wale raaste se!',
              isImportant: true,
              requiredClueId: 'clue_1_footprints',
            ),
          ],
        ),
        Character(
          id: 'char_dinesh',
          name: 'Dinesh Sharma',
          role: 'Padosi',
          emoji: '👴',
          description: 'Theek samne rehte hain. Har baat pe nazar rakhte hain.',
          suspicionLevel: 20,
          dialogues: [
            DialogueBranch(
              id: 'd1_dinesh_1',
              trigger: 'Aapne kuch dekha?',
              response:
                  'Haan bhai! Raat ko ek aadmi neem ke neeche khada tha. Maine socha koi baahar ghumne aaya hoga. Andhera tha toh chehra nahi dikha.',
              followUpIds: ['d1_dinesh_2'],
            ),
            DialogueBranch(
              id: 'd1_dinesh_2',
              trigger: 'Kitne baje ka waqt tha?',
              response:
                  'Raat ke karib dedh do baje. Mujhe neend nahi aati toh main darwaze pe khada tha. Woh aadmi peechhe ki taraf gaya — dewar ke paas.',
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
          description: 'Thaka hua, chai pi raha hai. Kehta hai natural death hai.',
          suspicionLevel: 0,
          dialogues: [
            DialogueBranch(
              id: 'd1_insp_1',
              trigger: 'Yeh murder hai?',
              response:
                  'Dekho bhai, darwaza andar se band tha. Koi andar aaya kaise? Natural death lagti hai. Neend ki dawai zyada le li hogi...',
              followUpIds: ['d1_insp_2'],
            ),
            DialogueBranch(
              id: 'd1_insp_2',
              trigger: 'Peechle darwaze ka taala?',
              response:
                  'Kya...? Peechla darwaza...? Humne toh sirf aage wala check kiya. Agar wakai taala toda gaya hai... toh yeh case alag hai.',
              requiredClueId: 'clue_1_key',
              isImportant: true,
              revealClue: 'clue_1_letter',
            ),
          ],
        ),
        Character(
          id: 'char_vikram',
          name: 'Vikram — "Bhai"',
          role: 'Ramesh ka bhai (Suspect)',
          emoji: '🕵️',
          description:
              'Door se dekha tune use. Mohalle ki gali mein chhupta phir raha hai. Bohot nervous lag raha hai.',
          suspicionLevel: 85,
          dialogues: [
            DialogueBranch(
              id: 'd1_vikram_1',
              trigger: 'Tum yahan kya kar rahe ho?',
              response:
                  'Main... main bhai ki khabar sunke aaya. Bohot bura laga. Hum dono mein thoda hua tha... lekin khoon ka rishta toh hota hai na...',
              followUpIds: ['d1_vikram_2', 'd1_vikram_3'],
            ),
            DialogueBranch(
              id: 'd1_vikram_2',
              trigger: 'Raat ko tum haveli gaye the?',
              response:
                  'Nahi! Main toh... main toh apne ghar pe tha. Koi witness bhi nahi... main akela rehta hoon. Lekin main wahan nahi gaya!',
              isImportant: true,
            ),
            DialogueBranch(
              id: 'd1_vikram_3',
              trigger: 'Yeh chithi tumne likhi?',
              response:
                  '(haath kaanpne lage) Woh chithi... tum kahan se laaye? Main... 40 saal pehle Ramesh ne meri zameen harap li thi. Meri maa ki zameen! Lekin main... maine kuch nahi kiya...',
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
      title: 'Kabristan Ka Darwaza',
      subtitle: 'Muradon ki basti mein ek zinda raaz...',
      location: 'Lucknow — Mohalla Chaand Bagh',
      backgroundEmoji: '⚰️',
      mystery:
          'Chaand Bagh ke purane kabristan mein raat ko roshan roshni dikhi. Chowkidar Hafeez bhai ki maut qabr ke andar hui — lekin koi nishan nahi. Kya sach mein bhoot hain? Ya kuch aur?',
      clues: [
        Clue(
          id: 'clue_2_matches',
          name: 'Bikhri Maachis',
          description: 'Qabr ke paas maachis ki teeliyan. Kisi ne raat mein roshni ki thi.',
          emoji: '🔥',
          location: 'Darwaza',
          isImportant: true,
        ),
        Clue(
          id: 'clue_2_gold',
          name: 'Mitti mein Sona',
          description: 'Qabr ki mitti mein dabaye gaye purane sone ke sikke.',
          emoji: '💰',
          location: 'Qabr',
          isImportant: true,
        ),
        Clue(
          id: 'clue_2_amulet',
          name: 'Toota Taweez',
          description: 'Hafeez bhai ka taweez toota hua pada hai. Kisi ne zor se kheencha tha.',
          emoji: '📿',
          location: 'Purani Jhopdi',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_moulvi',
          name: 'Moulvi Sahab',
          role: 'Imam',
          emoji: '👳',
          description: 'Dargah ke paas rehte hain. Bhoot pret pe yakeen karte hain.',
          suspicionLevel: 10,
          dialogues: [
            DialogueBranch(
              id: 'd2_moulvi_1',
              trigger: 'Hafeez bhai ki maut kaise hui?',
              response: 'Jinnat ka saya hai! Raat ko us qabr se ajeeb awaazein aati thin. Hafeez wahan akela gaya tha...',
              followUpIds: ['d2_moulvi_2'],
            ),
            DialogueBranch(
              id: 'd2_moulvi_2',
              trigger: 'Aapne roshni dekhi thi?',
              response: 'Haan, maachis ki jhalak thi. Shayad koi jadu tona kar raha tha.',
              revealClue: 'clue_2_matches',
              isImportant: true,
            ),
          ],
        ),
        Character(
          id: 'char_rizwan',
          name: 'Rizwan',
          role: 'Qabar Khodnewala (Suspect)',
          emoji: '⛏️',
          description: 'Kabristan ka kaam karta hai. Thoda ghabraya hua hai.',
          suspicionLevel: 80,
          dialogues: [
            DialogueBranch(
              id: 'd2_rizwan_1',
              trigger: 'Raat ko tum kahan the?',
              response: 'Main toh so raha tha! Mera is qabr se koi lena dena nahi hai.',
              followUpIds: ['d2_rizwan_2'],
            ),
            DialogueBranch(
              id: 'd2_rizwan_2',
              trigger: 'Sone ke sikke kiske hain?',
              response: 'Sona?! Mujhe nahi pata... Hafeez ne mujhe udhar mitti khodte dekha tha... lekin main chori nahi kar raha tha!',
              requiredClueId: 'clue_2_gold',
              isImportant: true,
            ),
            DialogueBranch(
              id: 'd2_rizwan_3',
              trigger: 'To tumne us par hamla kiya?',
              response: 'Nahi! Usne mera taweez pakda aur main ghabra gaya... woh gir gaya aur uska sarr pathar se laga!',
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
      title: 'Kuan Wali Raat',
      subtitle: 'Gaon ka wo kuan jo chillata hai raat ko...',
      location: 'Rajasthan — Gaon Bhootgarh',
      backgroundEmoji: '🌑',
      mystery:
          'Bhootgarh gaon ke purane kuan mein se raat ko awaaz aati hai. Gaon wale kehte hain bhoot hai. Ek din ek ajnabi laash mili kuan ke paas. Khoon ka koi nishan nahi, bas rassi mili hai.',
      clues: [
        Clue(
          id: 'clue_3_rope',
          name: 'Geeli Rassi',
          description: 'Kuan ki rassi aadhi geeli hai aur kheenchi hui hai.',
          emoji: '🪢',
          location: 'Kuan',
          isImportant: true,
        ),
        Clue(
          id: 'clue_3_cloth',
          name: 'Phata Kapda',
          description: 'Rassi ke paas ek phata hua laal kapda uljha hua hai.',
          emoji: '🧣',
          location: 'Ped',
          isImportant: true,
        ),
      ],
      characters: [
        Character(
          id: 'char_sarpanch',
          name: 'Sarpanch',
          role: 'Gaon ka Mukhiya',
          emoji: '👨‍🌾',
          description: 'Robe wala aadmi, par kisi baat se darta hai.',
          suspicionLevel: 40,
          dialogues: [
            DialogueBranch(
              id: 'd3_sarpanch_1',
              trigger: 'Kuan ke paas kya hua?',
              response: 'Woh kuan shaapit hai! Koi uske paas nahi jata.',
              followUpIds: ['d3_sarpanch_2'],
            ),
            DialogueBranch(
              id: 'd3_sarpanch_2',
              trigger: 'Ye laal kapda kiska hai?',
              response: 'Ye to Meera ka lagta hai... woh raat ko wahan kya kar rahi thi?',
              requiredClueId: 'clue_3_cloth',
              isImportant: true,
            ),
          ],
        ),
        Character(
          id: 'char_meera',
          name: 'Meera',
          role: 'Gaon ki Ladki (Suspect)',
          emoji: '🧕',
          description: 'Akele ghoomti hai, sabse darti hai.',
          suspicionLevel: 90,
          dialogues: [
            DialogueBranch(
              id: 'd3_meera_1',
              trigger: 'Ajnabi koun tha?',
              response: 'Mujhe nahi pata... main wahan nahi thi.',
              followUpIds: ['d3_meera_2'],
            ),
            DialogueBranch(
              id: 'd3_meera_2',
              trigger: 'Rassi kyu kheenchi thi tumne?',
              response: 'Usne mujhe dhamkaya tha! Mujhe bachaane ke liye kuan mein dhakka dena pada...',
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
        name: 'Neem Ka Ped 🌳',
        emoji: '🌳',
        xPercent: 0.15,
        yPercent: 0.35,
        clueId: 'clue_1_footprints',
        description: 'Purana neem ka ped — hawayen bhi thhar gayi hain iske paas.',
      ),
      InvestigationSpot(
        id: 'spot_darwaza',
        name: 'Peechla Darwaza 🚪',
        emoji: '🚪',
        xPercent: 0.75,
        yPercent: 0.55,
        clueId: 'clue_1_key',
        description: 'Haveli ka peechla darwaza — zang laga hua lekin kuch taza nishan hain.',
      ),
      InvestigationSpot(
        id: 'spot_kamra',
        name: 'Bada Kamra 🛋️',
        emoji: '🛋️',
        xPercent: 0.45,
        yPercent: 0.4,
        clueId: 'clue_1_letter',
        description: 'Woh kamra jahan Ramesh Chacha ki laash mili. Purana furniture, dheemi roshni.',
      ),
      InvestigationSpot(
        id: 'spot_almari',
        name: 'Purani Almari 🗄️',
        emoji: '🗄️',
        xPercent: 0.62,
        yPercent: 0.3,
        clueId: 'clue_1_photo',
        description: 'Bhari hui almari — kapde, dastaavez, aur shayad kuch chhupa hua bhi.',
      ),
      InvestigationSpot(
        id: 'spot_kitchen',
        name: 'Bawarchi Khana 🍳',
        emoji: '🍳',
        xPercent: 0.28,
        yPercent: 0.65,
        clueId: 'clue_1_medicine',
        description: 'Chhota bawarchi khana — raakh thand ho chuki hai.',
      ),
    ];
  }

  static List<InvestigationSpot> getChapter2Spots() {
    return [
      InvestigationSpot(
        id: 'spot_qabr',
        name: 'Purani Qabr ⚰️',
        emoji: '⚰️',
        xPercent: 0.5,
        yPercent: 0.6,
        clueId: 'clue_2_gold',
        description: 'Hafeez ki laash yahan mili thi. Mitti taaza khudi hui hai.',
      ),
      InvestigationSpot(
        id: 'spot_gate',
        name: 'Kabristan Darwaza 🚪',
        emoji: '🚪',
        xPercent: 0.2,
        yPercent: 0.3,
        clueId: 'clue_2_matches',
        description: 'Yahan raat ke waqt roshni dekhi gayi thi.',
      ),
      InvestigationSpot(
        id: 'spot_hut',
        name: 'Chowkidar ki Jhopdi 🏚️',
        emoji: '🏚️',
        xPercent: 0.7,
        yPercent: 0.4,
        clueId: 'clue_2_amulet',
        description: 'Hafeez yahan sota tha. Samaan bikhra pada hai.',
      ),
    ];
  }

  static List<InvestigationSpot> getChapter3Spots() {
    return [
      InvestigationSpot(
        id: 'spot_kuan',
        name: 'Bhootgarh Kuan 🕳️',
        emoji: '🕳️',
        xPercent: 0.45,
        yPercent: 0.5,
        clueId: 'clue_3_rope',
        description: 'Bahut purana kuan, andar andhera aur sannata hai.',
      ),
      InvestigationSpot(
        id: 'spot_banyan',
        name: 'Bargad ka Ped 🌳',
        emoji: '🌳',
        xPercent: 0.2,
        yPercent: 0.3,
        clueId: 'clue_3_cloth',
        description: 'Ped ki shaakh par kuch atka hua hai.',
      ),
      InvestigationSpot(
        id: 'spot_fields',
        name: 'Khet 🌾',
        emoji: '🌾',
        xPercent: 0.75,
        yPercent: 0.6,
        clueId: null,
        description: 'Sookhe khet, yahan kuch nahi mila.',
      ),
    ];
  }

  static List<InvestigationSpot> getSpotsForChapter(String chapterId, String lang) {
    if (lang == 'english') return StoryDataEn.getSpotsForChapter(chapterId);
    
    if (chapterId == 'chapter_1') return getChapter1Spots();
    if (chapterId == 'chapter_2') return getChapter2Spots();
    if (chapterId == 'chapter_3') return getChapter3Spots();
    return [];
  }
}
