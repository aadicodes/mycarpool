import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create user if not exists
  Future<void> createUserIfNotExists(String phone, {String? name}) async {
    final doc = _db.collection('users').doc(phone);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'phone': phone,
        'name': name ?? '',
        'kids': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // create a group
  Future<String> createGroup(String groupName, String ownerPhone) async {
    final docRef = await _db.collection('groups').add({
      'name': groupName,
      'owner': ownerPhone,
      'members': [ownerPhone],
      'createdAt': FieldValue.serverTimestamp(),
    });
    // add group ref to user (optional denormalization)
    await _db.collection('users').doc(ownerPhone).update({
      'groups': FieldValue.arrayUnion([docRef.id]),
    });
    return docRef.id;
  }

  Stream<QuerySnapshot> groupsForUser(String phone) {
    // simple query: groups where members array contains user
    return _db
        .collection('groups')
        .where('members', arrayContains: phone)
        .snapshots();
  }

  Future<void> joinGroup(String groupId, String phone) async {
    final ref = _db.collection('groups').doc(groupId);
    await ref.update({
      'members': FieldValue.arrayUnion([phone]),
    });
    await _db.collection('users').doc(phone).update({
      'groups': FieldValue.arrayUnion([groupId]),
    });
  }
}
