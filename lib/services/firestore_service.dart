// import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create user if not exists
  Future<void> createUserIfNotExists(String phone, {String? name}) async {
    // Mock: do nothing
    return;
  }

  // create a group
  Future<String> createGroup(String groupName, String ownerPhone) async {
    // Mock: return a fake group id
    await Future.delayed(const Duration(milliseconds: 300));
    return 'mock_group_id';
  }

  // Stream<QuerySnapshot> groupsForUser(String phone) {
  //   // simple query: groups where members array contains user
  //   return _db
  //       .collection('groups')
  //       .where('members', arrayContains: phone)
  //       .snapshots();
  // }
  Stream<MockQuerySnapshot> groupsForUser(String phone) async* {
    // Mock: yield a snapshot with fake groups
    await Future.delayed(const Duration(milliseconds: 300));
    yield MockQuerySnapshot([
      MockDocument({'name': 'Morning School Run', 'members': ['Alice', 'Bob', 'Charlie']}),
      MockDocument({'name': 'Soccer Practice', 'members': ['Dave', 'Eve']}),
    ]);
  }

  Future<void> joinGroup(String groupId, String phone) async {
    // Mock: do nothing
    return;
  }
}

// Mock classes for QuerySnapshot and Document
class MockQuerySnapshot {
  final List<MockDocument> docs;
  MockQuerySnapshot(this.docs);
}

class MockDocument {
  final Map<String, dynamic> _data;
  MockDocument(this._data);
  Map<String, dynamic> data() => _data;
}
}
