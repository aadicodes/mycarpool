import 'package:flutter/material.dart';
import '../models/Group.dart'; // Adjust path if needed

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  bool _saving = false;

  // Instantiate the mock repo
  //final mockGroupRepo = InMemoryGroupRepository();
  var mockGroup = Group(
    name: 'Default',
    memberCount: 2,
    members: ['Default Member 1', 'Default Member 2'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Group name'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving
                  ? null
                  : () async {
                      setState(() => _saving = true);
                      try {
                        // Use mockRepo to add group
                        mockGroup = Group(
                          name: _nameCtrl.text.trim(),
                          memberCount: 2,
                          members: ['NewGroup Member 1', 'NewGroup Member 2'],
                        );
                        await Future.delayed(const Duration(milliseconds: 500));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Group "${_nameCtrl.text.trim()}" created (mock)',
                            ),
                          ),
                        );
                        Navigator.pop(context, mockGroup);
                        // Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      } finally {
                        setState(() => _saving = false);
                      }
                    },
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
