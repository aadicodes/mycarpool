// import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream<User?> get authStateChanges => _auth.authStateChanges();
  Stream<dynamic> get authStateChanges => Stream.value(null);

  // Future<void> signOut() => _auth.signOut();
  Future<void> signOut() async {
    // Mock: do nothing
    return;
  }

  /// Start phone auth: sends verification code to phone.
  Future<dynamic> signInWithPhoneNumberWeb(String phone) async {
    // Not used in native apps - web only: kept for reference.
    return null;
  }

  Future<void> verifyPhone({
    required String phone,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(dynamic e) verificationFailed,
    required void Function(dynamic credential) verificationCompleted,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    // Mock: always succeed and call codeSent with mock verificationId
    await Future.delayed(const Duration(milliseconds: 500));
    codeSent('mock_verification_id', 0);
  }

  Future<dynamic> signInWithSmsCode(
    String verificationId,
    String smsCode,
  ) async {
    // Mock: return a dummy credential object
    return MockUserCredential();
  }

  // User? get currentUser => _auth.currentUser;
  dynamic get currentUser => MockUser();
}

// Mock classes for user and credential
class MockUser {
  String? get phoneNumber => '+1234567890';
}

class MockUserCredential {
  MockUser? get user => MockUser();
}
