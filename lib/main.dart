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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// TODO: If using generated firebase_options.dart from FlutterFire CLI,
// import it and call DefaultFirebaseOptions.currentPlatform in Firebase.initializeApp.
// For brevity this example uses a basic Firebase.initializeApp() call.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthState())],
      child: MaterialApp(
        title: 'Carpool Starter',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthGate(),
      ),
    );
  }
}

// Simple AuthState to notify when user signs in
class AuthState extends ChangeNotifier {
  User? user;

  AuthState() {
    FirebaseAuth.instance.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  /*
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context);
    if (auth.user == null) {
      return const PhoneSignInScreen();
    }
    return GroupsListScreen();
  }
  */
  @override
  Widget build(BuildContext context) {
    return GroupsListScreen();
    ;
  }
}

// PHONE SIGN-IN SCREEN (uses Firebase Phone Auth)
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
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        setState(() => _codeSent = true);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
    setState(() => _loading = false);
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) return;
    final cred = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeController.text.trim(),
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(cred);
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

// GROUPS LIST SCREEN (shows user's groups and allows creating a new group)
class GroupsListScreen extends StatelessWidget {
  final _groupsRef = FirebaseFirestore.instance.collection('groups');

  GroupsListScreen({super.key});

  Future<void> _createGroup(BuildContext context) async {
    final name = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Create group'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Group name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
    if (name == null || name.isEmpty) return;
    /*
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await _groupsRef.add({
      'name': name,
      'members': [user.phoneNumber],
      'createdAt': FieldValue.serverTimestamp(),
      'schedules': {},
    });
    */
    // Optionally add reference to user doc or update user's group list
    // For simplicity we only create the group here.
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Carpools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _groupsRef
            .where('members', arrayContains: 'myPhone') //user.phoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty)
            return const Center(
              child: Text('No groups yet. Tap + to create one.'),
            );
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index];
              return ListTile(
                title: Text(d['name'] ?? 'Untitled'),
                subtitle: Text('Members: ${(d['members'] as List).length}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupDetailScreen(groupId: d.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createGroup(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// GROUP DETAIL SCREEN - manage members, schedules, kids
class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late final DocumentReference _groupRef;

  @override
  void initState() {
    super.initState();
    _groupRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId);
  }

  Future<void> _addKid() async {
    final name = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Add child name'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (name == null || name.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        // .doc(user.uid);
        .doc('myPhone');
    await userDoc.set({
      'phone': 'test', // user.phoneNumber,
      'kids': FieldValue.arrayUnion([name]),
    }, SetOptions(merge: true));
  }

  Future<void> _setAvailability() async {
    // Simple flow: pick weekday and time
    final weekday = await showDialog<int?>(
      context: context,
      builder: (ctx) {
        int selected = 1;
        return AlertDialog(
          title: const Text('Select day of week'),
          content: StatefulBuilder(
            builder: (ctx2, setSt) {
              return DropdownButton<int>(
                value: selected,
                items: List.generate(
                  7,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_weekdayLabel(i + 1)),
                  ),
                ),
                onChanged: (v) => setSt(() => selected = v ?? 1),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: const Text('Next'),
            ),
          ],
        );
      },
    );

    if (weekday == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (time == null) return;

    final user = FirebaseAuth.instance.currentUser!;
    final scheduleStr = '${_weekdayLabel(weekday)} ${time.format(context)}';

    // store under schedules.{phoneNumber} -> array of schedule strings
    await _groupRef.set({
      'schedules': {
        user.phoneNumber!: FieldValue.arrayUnion([scheduleStr]),
      },
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Availability set')));
  }

  String _weekdayLabel(int d) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[(d - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _groupRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null) return const Center(child: Text('Group not found'));
          final members = List<String>.from(data['members'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Text(
                  'Members (${members.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...members.map((m) => ListTile(title: Text(m))).toList(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _addKid,
                  icon: const Icon(Icons.child_care),
                  label: const Text('Add child name'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _setAvailability,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Set availability'),
                ),
                const SizedBox(height: 20),
                const Text('Schedules (raw):'),
                Text(data['schedules']?.toString() ?? 'No schedules'),
              ],
            ),
          );
        },
      ),
    );
  }
}

// NOTES & NEXT STEPS:
// - Calendar integration: use device_calendar or android_intent/url_launcher to add events.
// - Maps: use google_maps_flutter and place picker to choose destinations.
// - Reminders: combine Calendar events and flutter_local_notifications for in-app reminders.
// - Invitations: add a mechanism to send SMS invites or add members by phone number (update group's members array).
// - Security: secure Firestore rules so only group members can read/write their group.

// This starter focuses on structure & basic flows: phone auth, group create, adding kids & schedules.
// You can copy this file into lib/main.dart and run after completing Firebase configuration.
