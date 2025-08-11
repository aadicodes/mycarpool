// carpool_flutter_starter.dart
// Starter Flutter app skeleton for Carpool coordination
// NOTE: This starter uses Firebase (Auth + Firestore). You'll need to add
// your Firebase configuration files (GoogleService-Info.plist for iOS,
// google-services.json for Android) and enable Phone Authentication in
// the Firebase Console.

// USAGE STEPS (short):
// 1. Create Firebase project and enable Phone Authentication.
// 2. Add Android & iOS apps and download config files -> place them in your
//    android/app and ios/Runner directories respectively.
// 3. flutter pub get
// 4. flutter run

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'auth_state.dart';
import 'package:flutter/material.dart';
import 'package:my_carpool_app/models/mock_data.dart';
import 'package:my_carpool_app/screens/home_screen.dart';
// import 'package:provider/provider.dart';
// import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // run MyApp instance
  final repo = MockDataRepo.seeded();
  await repo.load();
  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, MockDataRepo? repository});

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [ChangeNotifierProvider(create: (_) => AuthState())],
    //   child: MaterialApp(
    //     title: 'My Carpool App',
    //     theme: ThemeData(primarySwatch: Colors.blue),
    //     home: const AuthGate(),
    //   ),
    // );
    return MaterialApp(
      title: 'My Carpool App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

// This starter focuses on structure & basic flows: phone auth, group create, adding kids & schedules.
// You can copy this file into lib/main.dart and run after completing Firebase configuration.

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpool Starter')),
      body: const Center(
        child: Text(
          'Firebase integration is disabled.\nBlank screen for UI preview.',
        ),
      ),
    );
  }
}
