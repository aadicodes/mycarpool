import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  const OtpScreen({
    required this.verificationId,
    required this.phone,
    super.key,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();
  bool _verifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('A code was sent to ${widget.phone}'),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _verifying
                  ? null
                  : () async {
                      setState(() => _verifying = true);
                      try {
                        // Mock: always succeed and go to home
                        await Future.delayed(const Duration(milliseconds: 500));
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      } finally {
                        setState(() => _verifying = false);
                      }
                    },
              child: _verifying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      } finally {
                        setState(() => _verifying = false);
                      }
                    },
              child: _verifying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
