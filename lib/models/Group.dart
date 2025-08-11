import 'dart:async';
import 'dart:ffi';

// ---------- Domain model ----------
class Group {
  final String? id;
  final String name;
  final int? memberCount;
  final List<String>? members;

  const Group({
    this.id = "1",
    required this.name,
    this.memberCount = 1,
    this.members = const [],
  });

  Group copyWith({String? name, int? memberCount}) => Group(
    id: id,
    name: name ?? this.name,
    memberCount: memberCount ?? this.memberCount,
  );

  @override
  String toString() => 'Group(id: $id, name: $name, memberCount: $memberCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          memberCount == other.memberCount;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ memberCount.hashCode;
}

// ---------- Repository contract ----------
abstract class GroupRepository {
  Future<Group> add({
    required String name,
    required int memberCount,
    List<String>? members,
  });
  Future<Group?> get(String id);
  Future<List<Group>> all();
  Stream<List<Group>> watchAll();
  Future<Group> update(String id, {String? name, int? memberCount});
  Future<void> delete(String id);
  Future<void> clear();
  void dispose();
  Future<bool> isEmpty();
  int length();
}

// ---------- In-memory mock implementation ----------
class InMemoryGroupRepository implements GroupRepository {
  final Map<String, Group> _store = {};
  final StreamController<List<Group>> _controller =
      StreamController<List<Group>>.broadcast();

  int _seq = 0;

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  void _emit() {
    final list = _store.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    _controller.add(list);
  }

  @override
  Future<Group> add({
    required String name,
    int? memberCount,
    List<String>? members,
  }) async {
    final id = _newId();
    final Group1 = Group(
      id: id,
      name: name,
      memberCount: memberCount,
      members: members,
    );
    _store[id] = Group1;
    _emit();
    return Group1;
  }

  @override
  Future<bool> isEmpty() async => _store.isEmpty;

  @override
  Future<Group?> get(String id) async => _store[id];

  @override
  Future<List<Group>> all() async => _store.values.toList();

  @override
  int length() => _store.values.toList().length;

  @override
  Stream<List<Group>> watchAll() => _controller.stream;

  @override
  Future<Group> update(String id, {String? name, int? memberCount}) async {
    final existing = _store[id];
    if (existing == null) {
      throw StateError('Group not found: $id');
    }
    final updated = existing.copyWith(name: name, memberCount: memberCount);
    _store[id] = updated;
    _emit();
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    final removed = _store.remove(id);
    if (removed != null) _emit();
  }

  @override
  Future<void> clear() async {
    _store.clear();
    _emit();
  }

  @override
  void dispose() {
    _controller.close();
  }
}
// ---------- Mock data for testing ----------