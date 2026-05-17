// // lib/main.dart — UPDATED (Firebase ke saath)
// // Purane main.dart ko IS se REPLACE karo

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // FlutterFire CLI se generate hoga
// import 'services/game_provider.dart';
// import 'services/ad_service.dart';
// import 'utils/app_theme.dart';
// import 'screens/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Portrait mode lock
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   // 🔥 Firebase initialize karo
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // AdMob initialize karo
//   await AdService().initialize();

//   runApp(const MohallaMysteryApp());
// }

// class MohallaMysteryApp extends StatelessWidget {
//   const MohallaMysteryApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => GameProvider(),
//       child: MaterialApp(
//         title: 'Mohalla Mystery',
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.darkTheme,
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
