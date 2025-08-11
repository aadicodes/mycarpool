// phone_signin_screen.dart
// This file contains the PhoneSignInScreen widget for phone number authentication
// using Firebase Auth.

import 'package:flutter/material.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  Future<void> _sendCode() async {
    setState(() => _loading = true);
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: _phoneController.text.trim(),
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     // Auto-retrieval or instant verification
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    //   },
    //   verificationFailed: (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Verification failed: ${e.message}')),
    //     );
    //   },
    //   codeSent: (verificationId, resendToken) {
    //     _verificationId = verificationId;
    //     setState(() => _codeSent = true);
    //   },
    //   codeAutoRetrievalTimeout: (verificationId) {
    //     _verificationId = verificationId;
    //   },
    // );
    // Mock: always succeed and set codeSent
    await Future.delayed(const Duration(milliseconds: 500));
    _verificationId = 'mock_verification_id';
    setState(() => _codeSent = true);
    setState(() => _loading = false);
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) return;
    // final cred = PhoneAuthProvider.credential(
    //   verificationId: _verificationId!,
    //   smsCode: _codeController.text.trim(),
    // );
    try {
      // await FirebaseAuth.instance.signInWithCredential(cred);
      // Mock: always succeed
      await Future.delayed(const Duration(milliseconds: 500));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signed in (mock)')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number (E.164 format, e.g. +15551234567)',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _sendCode,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Send code'),
            ),
            const SizedBox(height: 20),
            if (_codeSent) ...[
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'SMS code'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Verify & Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
