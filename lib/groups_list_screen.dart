// groups_list_screen.dart
// Groups list screen for Carpool coordination app

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'group_detail_screen.dart';

class GroupsListScreen extends StatelessWidget {
  // final _groupsRef = FirebaseFirestore.instance.collection('groups');

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
    // Mock: just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Group "$name" created (mock)')));
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;

    // Mock group data
    final mockGroups = [
      {
        'id': '1',
        'name': 'Morning School Run',
        'members': ['Alice', 'Bob', 'Charlie'],
      },
      {
        'id': '2',
        'name': 'Soccer Practice',
        'members': ['Dave', 'Eve'],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Carpools'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // onPressed: () async {
            //   await FirebaseAuth.instance.signOut();
            // },
            onPressed: () {}, // No-op for mock
          ),
        ],
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: _groupsRef
      //       .where('members', arrayContains: 'myPhone') //user.phoneNumber)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting)
      //       return const Center(child: CircularProgressIndicator());
      //     final docs = snapshot.data?.docs ?? [];
      //     if (docs.isEmpty)
      //       return const Center(
      //         child: Text('No groups yet. Tap + to create one.'),
      //       );
      //     return ListView.builder(
      //       itemCount: docs.length,
      //       itemBuilder: (context, index) {
      //         final d = docs[index];
      //         return ListTile(
      //           title: Text(d['name'] ?? 'Untitled'),
      //           subtitle: Text('Members: ${(d['members'] as List).length}'),
      //           onTap: () => Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => GroupDetailScreen(groupId: d.id),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      body: mockGroups.isEmpty
          ? const Center(child: Text('No groups yet. Tap + to create one.'))
          : ListView.builder(
              itemCount: mockGroups.length,
              itemBuilder: (context, index) {
                final d = mockGroups[index];
                return ListTile(
                  title: Text((d['name'] as String?) ?? 'Untitled'),
                  subtitle: Text('Members: ${(d['members'] as List).length}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GroupDetailScreen(groupId: d['id'] as String),
                    ),
                  ),
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
