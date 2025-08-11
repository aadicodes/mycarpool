// group_detail_screen.dart
// GroupDetailScreen widget for managing group details in the Carpool app

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  // late final DocumentReference _groupRef;

  // Mock data
  List<String> members = ['Alice', 'Bob', 'Charlie'];
  List<String> schedules = ['Mon 8:00 AM', 'Tue 8:15 AM', 'Wed 8:30 AM'];

  @override
  void initState() {
    super.initState();
    // _groupRef = FirebaseFirestore.instance
    //     .collection('groups')
    //     .doc(widget.groupId);
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

    // final user = FirebaseAuth.instance.currentUser!;
    // final userDoc = FirebaseFirestore.instance
    //     .collection('users')
    //     // .doc(user.uid);
    //     .doc('myPhone');
    // await userDoc.set({
    //   'phone': 'test', // user.phoneNumber,
    //   'kids': FieldValue.arrayUnion([name]),
    // }, SetOptions(merge: true));

    // For mock: just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added child "$name" (mock)')));
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

    // final user = FirebaseAuth.instance.currentUser!;
    // final scheduleStr = '${_weekdayLabel(weekday)} ${time.format(context)}';

    // store under schedules.{phoneNumber} -> array of schedule strings
    // await _groupRef.set({
    //   'schedules': {
    //     user.phoneNumber!: FieldValue.arrayUnion([scheduleStr]),
    //   },
    // }, SetOptions(merge: true));

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text('Availability set')));

    // For mock: just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Availability set (mock)')));
  }

  String _weekdayLabel(int d) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[(d - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Group Details')),
    //   body: StreamBuilder<DocumentSnapshot>(
    //     stream: _groupRef.snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting)
    //         return const Center(child: CircularProgressIndicator());
    //       final data = snapshot.data?.data() as Map<String, dynamic>?;
    //       if (data == null) return const Center(child: Text('Group not found'));
    //       final members = List<String>.from(data['members'] ?? []);

    //       return Padding(
    //         padding: const EdgeInsets.all(12.0),
    //         child: ListView(
    //           children: [
    //             Text(
    //               'Members (${members.length})',
    //               style: Theme.of(context).textTheme.titleLarge,
    //             ),
    //             ...members.map((m) => ListTile(title: Text(m))).toList(),
    //             const SizedBox(height: 20),
    //             ElevatedButton.icon(
    //               onPressed: _addKid,
    //               icon: const Icon(Icons.child_care),
    //               label: const Text('Add child name'),
    //             ),
    //             const SizedBox(height: 12),
    //             ElevatedButton.icon(
    //               onPressed: _setAvailability,
    //               icon: const Icon(Icons.schedule),
    //               label: const Text('Set availability'),
    //             ),
    //             const SizedBox(height: 20),
    //             const Text('Schedules (raw):'),
    //             Text(data['schedules']?.toString() ?? 'No schedules'),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: Padding(
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
            const Text('Schedules (mock):'),
            ...schedules.map((s) => Text(s)).toList(),
          ],
        ),
      ),
    );
  }
}
