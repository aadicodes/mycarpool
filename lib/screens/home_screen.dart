import 'package:flutter/material.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:my_carpool_app/models/Group.dart';
import 'package:my_carpool_app/models/mock_data.dart';
import 'create_group_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final mockGroups = [
    {
      'name': 'Morning School Run',
      'members': ['Alice', 'Bob', 'Charlie'],
    },
    {
      'name': 'Soccer Practice',
      'members': ['Dave', 'Eve'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Carpools'),
        actions: [
          IconButton(
            onPressed: () {}, // No-op for mock
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: mockGroups.isEmpty
          ? const Center(child: Text('No groups yet. Create one!'))
          : ListView.builder(
              itemCount: mockGroups.length,
              itemBuilder: (context, i) {
                final d = mockGroups[i];
                return ListTile(
                  title: Text(d['name'] as String? ?? 'Unnamed'),
                  subtitle: Text('Members: ${(d['members'] as List).length}'),
                  onTap: () {
                    // TODO: open group details / schedule screen
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
        ),
        child: const Icon(Icons.group_add),
      ),
    );
  }
}
