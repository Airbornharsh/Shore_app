import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cloud_firestore {
  static void updateAvailability() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "name": _auth.currentUser?.displayName ?? _auth.currentUser!.email,
      "email": _auth.currentUser?.email,
      "uid": _auth.currentUser?.uid,
      "auth_time": DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(data);
    } catch (e) {
      print(e);
    }
  }
}
