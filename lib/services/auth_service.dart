import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signOut() => _auth.signOut();

  /// Start phone auth: sends verification code to phone.
  Future<ConfirmationResult?> signInWithPhoneNumberWeb(String phone) async {
    // Not used in native apps - web only: kept for reference.
    return null;
  }

  Future<void> verifyPhone({
    required String phone,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(PhoneAuthCredential credential)
    verificationCompleted,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Automatic on some devices
        verificationCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e);
      },
      codeSent: (verificationId, resendToken) {
        codeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // timeout
      },
      timeout: timeout,
    );
  }

  Future<UserCredential> signInWithSmsCode(
    String verificationId,
    String smsCode,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  User? get currentUser => _auth.currentUser;
}
