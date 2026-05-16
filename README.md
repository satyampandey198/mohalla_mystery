# 👁️ Mohalla Mystery — मोहल्ला मिस्ट्री
### Desi Horror Puzzle Game | Flutter

---

## 🎮 Game Overview

**Mohalla Mystery** ek unique desi horror puzzle game hai jisme player ek detective banta hai aur Indian mohalle ke haunted mysteries solve karta hai.

### Features:
- 🗺️ **Tap-based investigation** — Spots explore karo, clues dhundho
- 💬 **Rich dialogue system** — Suspects se Hindi mein baat karo
- 📝 **Detective notebook** — Saare clues track karo
- 🎯 **Accusation system** — Sahi mujrim pakdo
- 💡 **Hint system** — Rewarded ads se hints kamao
- 💰 **AdMob integration** — Banner + Interstitial + Rewarded ads

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── game_models.dart         # Data models (Chapter, Clue, Character, etc.)
├── data/
│   └── story_data.dart          # Game story, dialogues, chapters (EDIT HERE)
├── services/
│   ├── game_provider.dart       # State management (Provider)
│   └── ad_service.dart          # Google AdMob integration
├── utils/
│   └── app_theme.dart           # Dark horror theme, colors, fonts
├── screens/
│   ├── splash_screen.dart       # Animated splash
│   ├── main_menu_screen.dart    # Home screen with stats
│   ├── chapter_select_screen.dart # Chapter list
│   ├── investigation_screen.dart  # Main gameplay (map + suspects)
│   ├── dialogue_screen.dart     # Chat with suspects
│   ├── accusation_screen.dart   # Final accusation
│   └── mystery_solved_screen.dart # Victory screen
└── widgets/
    ├── clue_found_overlay.dart  # Clue discovery popup
    └── notes_panel.dart         # Detective notebook overlay
```

---

## 🚀 Setup Guide (Step by Step)

### Step 1: Flutter Install Karo
```bash
# Flutter SDK download karo: https://flutter.dev/docs/get-started/install
flutter --version  # 3.0+ hona chahiye
```

### Step 2: Project Setup
```bash
# Is folder ko open karo
cd mohalla_mystery

# Dependencies install karo
flutter pub get
```

### Step 3: Assets Create Karo
```bash
# Ye folders banao
mkdir -p assets/images assets/audio assets/data assets/fonts
```

### Step 4: AdMob Setup (IMPORTANT for earning!)

1. **AdMob Account banao**: https://admob.google.com
2. **New App add karo** → Android → "Mohalla Mystery"
3. **3 Ad Units banao**:
   - Banner Ad → copy `ca-app-pub-XXXXX/XXXXX`
   - Interstitial Ad → copy `ca-app-pub-XXXXX/XXXXX`
   - Rewarded Ad → copy `ca-app-pub-XXXXX/XXXXX`

4. **`lib/services/ad_service.dart`** mein replace karo:
```dart
static const String _bannerAdUnitId = 'ca-app-pub-YOUR_ID/YOUR_BANNER_ID';
static const String _interstitialAdUnitId = 'ca-app-pub-YOUR_ID/YOUR_INTERSTITIAL_ID';
static const String _rewardedAdUnitId = 'ca-app-pub-YOUR_ID/YOUR_REWARDED_ID';
```

5. **`android/app/src/main/AndroidManifest.xml`** mein replace karo:
```xml
android:value="ca-app-pub-YOUR_APP_ID~YOUR_APP_ID"/>
```

### Step 5: Run Karo
```bash
# Android device connect karo ya emulator start karo
flutter run

# Release APK banao
flutter build apk --release
```

---

## 💰 Earning Strategy (Ads se Paise)

| Ad Type | Kab Show Hoga | Earning |
|---------|--------------|---------|
| **Banner Ad** | Main Menu + Investigation screen | Low per click |
| **Interstitial** | Chapter complete hone ke baad (Accusation screen se pehle) | Medium per show |
| **Rewarded** | Hints lene ke liye (3 hints = 1 ad) | High per complete view |

**Expected Earning** (10,000+ downloads pe):
- 1,000 DAU × ₹0.5 avg RPM = ~₹15,000-50,000/month

---

## ✏️ Naya Chapter Kaise Add Karo

`lib/data/story_data.dart` mein `chapter4()` function banao:

```dart
static Chapter chapter4() {
  return Chapter(
    id: 'chapter_4',
    title: 'Pahadon Ka Saaya',
    subtitle: 'Paharon mein koi chhupa hai...',
    location: 'Himachal Pradesh — Gaon Chail',
    backgroundEmoji: '🏔️',
    mystery: 'Aapki mystery yahan likho...',
    clues: [
      Clue(id: 'c4_1', name: 'Clue naam', description: 'Clue description', emoji: '🔍', location: 'Jagah'),
    ],
    characters: [/* suspects */],
    solution: 'suspect_id',
  );
}
```

---

## 🎨 Theme Customize Karo

`lib/utils/app_theme.dart` mein colors change karo:

```dart
static const Color primary = Color(0xFFD4A017);   // Gold color
static const Color accent = Color(0xFFB5451B);    // Red accent
static const Color bgDeep = Color(0xFF0A0A0F);    // Background
```

---

## 📱 Play Store Upload

1. `flutter build appbundle --release`
2. Google Play Console → New App → Upload `.aab` file
3. Content rating complete karo (Horror game = Teen+)
4. Pricing: **Free with Ads** → Maximum downloads

---

## 🛠️ Troubleshooting

```bash
# Dependencies issues
flutter clean && flutter pub get

# Android build issues  
cd android && ./gradlew clean

# AdMob not showing (development mein normal hai)
# Test ads automatically show hote hain real device pe
```

---

## 📞 Dependencies Used

| Package | Use |
|---------|-----|
| `provider` | State management |
| `google_mobile_ads` | AdMob ads |
| `shared_preferences` | Game save/load |
| `flutter_animate` | Smooth animations |
| `google_fonts` | Cinzel + Noto Sans Devanagari |
| `vibration` | Haptic feedback |
| `audioplayers` | Sound effects (future) |

---

**Made with ❤️ for Desi Horror Game Lovers**
