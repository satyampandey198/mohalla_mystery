# 🔥 Mohalla Mystery — Firebase Integration Guide
## Automatic Level Upload System

---

## 📦 Is ZIP mein kya hai

```
flutter_integration/
├── firebase_service.dart      → Firestore se chapters fetch karta hai
├── game_provider_updated.dart → GameProvider (Firebase wala)
├── loading_screen.dart        → Loading/Error screen widgets
├── main_updated.dart          → main.dart (Firebase initialized)
└── pubspec_updated.yaml       → Firebase dependencies

admin_panel/
└── index.html                 → Web admin panel (chapters upload karo)

firestore_rules/
└── firestore.rules            → Security rules (Firestore Console mein paste karo)
```

---

## 🚀 Step-by-Step Setup

### STEP 1: Firebase Project Banao

1. **https://console.firebase.google.com** jaao
2. **"Create a project"** → Name: `mohalla-mystery`
3. Google Analytics: OFF kar do (simple rakho)
4. **Continue** → Project ready!

---

### STEP 2: Firestore Database Enable Karo

1. Left sidebar → **Firestore Database**
2. **"Create database"** click karo
3. **"Start in test mode"** select karo (baad mein rules lagayenge)
4. Location: **asia-south1** (India — fastest)
5. **Enable** karo

---

### STEP 3: Flutter App Connect Karo

```bash
# FlutterFire CLI install karo
dart pub global activate flutterfire_cli

# Firebase login karo
firebase login

# App ke folder mein jaao
cd mohalla_mystery

# Firebase configure karo (android/ios dono automatically setup ho jayenge)
flutterfire configure --project=mohalla-mystery
```

Ye command `lib/firebase_options.dart` file automatically generate kar dega.

---

### STEP 4: Dependencies Add Karo

`pubspec.yaml` mein add karo (ya `pubspec_updated.yaml` use karo):

```yaml
firebase_core: ^3.1.0
cloud_firestore: ^5.1.0
firebase_auth: ^5.1.0
```

```bash
flutter pub get
```

---

### STEP 5: Files Replace Karo

```
firebase_service.dart      → lib/services/firebase_service.dart
game_provider_updated.dart → lib/services/game_provider.dart  (REPLACE)
main_updated.dart          → lib/main.dart  (REPLACE)
```

---

### STEP 6: Firestore Security Rules Lagao

1. Firebase Console → Firestore → **Rules** tab
2. `firestore_rules/firestore.rules` ka content paste karo
3. **Publish** karo

---

### STEP 7: Admin Panel Setup Karo

1. `admin_panel/index.html` open karo
2. Apna Firebase Config paste karo (Console → Project Settings → Web App):

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "mohalla-mystery.firebaseapp.com",
  projectId: "mohalla-mystery",
  storageBucket: "mohalla-mystery.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

3. **Admin user banao**: Firebase Console → Authentication → Add user
4. `index.html` browser mein open karo → login karo → chapter upload karo!

---

### STEP 8: Game Model Update Karo

`lib/models/game_models.dart` mein `Chapter` class mein `spots` field add karo:

```dart
class Chapter {
  // ... existing fields ...
  final List<InvestigationSpot> spots;  // ← YE ADD KARO

  Chapter({
    // ... existing params ...
    required this.spots,  // ← YE ADD KARO
  });
}
```

---

## 🎮 Kaise Kaam Karta Hai

```
Admin Panel (Browser)
       ↓
   Chapter fill karo
   (title, clues, characters, dialogues)
       ↓
   "Firestore mein Upload Karo" button
       ↓
   Firebase Firestore (Cloud Database)
       ↓
   User ka Flutter App (auto-fetch on startup)
       ↓
   Offline cache bhi save hota hai
```

**Bina app update ke** naya chapter publish ho jaata hai! ✨

---

## 📤 Admin Panel Features

| Feature | Description |
|---------|-------------|
| **Upload Chapter** | Form se chapter, clues, characters, spots add karo |
| **JSON Import** | Pura JSON paste karke ek click mein upload |
| **Manage Chapters** | Live chapters dekhna, delete karna |
| **Lock/Unlock** | Chapter locked rakh ke baad unlock karo |

---

## 🔄 Auto-Refresh Logic

```dart
// App start hote hi Firebase se chapters fetch hote hain
// Offline hai toh cached data use hota hai
// Naya chapter aane pe user ko notification milti hai
```

---

## 💡 Pro Tips

- **Chapters batches mein upload karo**: Pehle lock chapters upload karo,
  phir unlock karo jab ready ho
- **Version field**: `updatedAt` se Flutter app check karta hai kya update aaya
- **Test karo**: Pehle test mode mein Firestore use karo, baad mein security rules lagao
- **Backup**: Admin panel se JSON export karke local save rakhao

---

## ❓ Common Issues

**"Permission denied" error:**
→ Firestore rules check karo — test mode mein hona chahiye ya rules sahi honi chahiye

**"Chapter load nahi ho raha":**
→ `flutterfire configure` dobara run karo
→ `google-services.json` (Android) sahi jagah hai ya nahi check karo (`android/app/`)

**"Admin login nahi ho raha":**
→ Firebase Console → Authentication → Email/Password enable hai?
→ Admin user add kiya hai?
