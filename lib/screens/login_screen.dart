import 'package:flutter/material.dart';
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
                      // Mock: always succeed and go to OTP screen
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() => _sending = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpScreen(
                            verificationId: 'mock_verification_id',
                            phone: phone,
                          ),
                        ),
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
