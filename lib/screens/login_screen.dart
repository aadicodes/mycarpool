import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController(
    text: '+1',
  ); // default country code if you like
  bool _sending = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone (+countrycode)',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sending
                  ? null
                  : () async {
                      setState(() => _sending = true);
                      final phone = _phoneCtrl.text.trim();
                      await auth.verifyPhone(
                        phone: phone,
                        codeSent: (verificationId, token) {
                          setState(() => _sending = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(
                                verificationId: verificationId,
                                phone: phone,
                              ),
                            ),
                          );
                        },
                        verificationFailed: (e) {
                          setState(() => _sending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Verification failed: ${e.message}',
                              ),
                            ),
                          );
                        },
                        verificationCompleted: (credential) async {
                          // auto sign in: credential contains phone auth
                          await auth.signInWithSmsCode(
                            credential.verificationId ?? '',
                            '',
                          ); // usually automatic
                        },
                      );
                    },
              child: _sending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Send Code'),
            ),
            const SizedBox(height: 12),
            const Text(
              'For development: add test numbers in Firebase console.',
            ),
          ],
        ),
      ),
    );
  }
}
