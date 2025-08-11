// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  // User? user;
  dynamic user;

  AuthState() {
    // FirebaseAuth.instance.authStateChanges().listen((u) {
    //   user = u;
    //   notifyListeners();
    // });
    // Mock: always signed in
    user = MockUser();
    notifyListeners();
  }
}

class MockUser {
  String? get phoneNumber => '+1234567890';
}
