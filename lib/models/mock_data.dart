import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// You need to define or import InMemoryNoteRepository and Note.
// For this mock, add minimal placeholder classes:

class Note {
  final String id;
  final String content;
  Note(this.id, this.content);
}

class InMemoryNoteRepository {
  final List<Note> _notes;
  InMemoryNoteRepository._(this._notes);

  static InMemoryNoteRepository seeded() =>
      InMemoryNoteRepository._([Note('1', 'Sample note')]);

  String exportJson() {
    // Simple mock: export notes as JSON string
    return '[{"id":"1","content":"Sample note"}]';
  }

  void importJson(String jsonStr) {
    // Simple mock: do nothing
  }

  Future<Note> add(Note note) async {
    _notes.add(note);
    return note;
  }

  Future<Note> update(Note note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) _notes[idx] = note;
    return note;
  }

  Future<void> delete(String id) async {
    _notes.removeWhere((n) => n.id == id);
  }
}

class MockDataRepo extends InMemoryNoteRepository {
  MockDataRepo.seeded() : super._([]);

  static const _fileName = 'mock_notes.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
    // On iOS Simulator this resolves to a sandboxed Documents/ path.
  }

  Future<void> load() async {
    final f = await _file();
    if (await f.exists()) {
      final jsonStr = await f.readAsString();
      importJson(jsonStr);
    } else {
      // Seed and persist on first launch
      importJson(InMemoryNoteRepository.seeded().exportJson());
      await save();
    }
  }

  Future<void> save() async {
    final f = await _file();
    await f.writeAsString(exportJson());
  }

  @override
  Future<Note> add(Note note) async {
    final n = await super.add(note);
    // unawaited(save());
    save();
    return n;
  }

  @override
  Future<Note> update(Note note) async {
    final n = await super.update(note);
    // unawaited(save());
    save();
    return n;
  }

  @override
  Future<void> delete(String id) async {
    await super.delete(id);
    // unawaited(save());
    save();
  }
}
