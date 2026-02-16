import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  SyncService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<void> syncAll() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'profile': {'updated_at': FieldValue.serverTimestamp()},
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('SyncService error: $error');
    }
  }
}
