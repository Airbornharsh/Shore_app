import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cloud_firestore {
  static get getFirestore {
    return FirebaseFirestore.instance;
  }

  static get getAuth {
    return FirebaseAuth.instance;
  }

  static void createUser(String displayName, int phoneNumber) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "name": displayName,
      "emailId": _auth.currentUser?.email,
      "phoneNumber": phoneNumber,
      "uid": _auth.currentUser?.uid,
      "userCreated": DateTime.now().millisecondsSinceEpoch,
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

  static void updateAvailability() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "auth_time": DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);
    } catch (e) {
      print(e);
    }
  }

  static void updateLastSeen() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "last_seen": DateTime.now().millisecondsSinceEpoch,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);
    } catch (e) {
      print(e);
    }
  }

  static void updateProfile(String displayName, int phoneNumber) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "name": displayName,
      "phoneNumber": phoneNumber,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);
    } catch (e) {
      print(e);
    }
  }

  static void updateProfileImage(String imageUrl) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;
    final data = {
      "profileImage": imageUrl,
    };

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);
    } catch (e) {
      print(e);
    }
  }

  static Future<String> sendMessage(
      {required String roomId,
      required String from,
      required String message,
      required int time,
      required String to,
      required bool read,
      required String type}) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return "";

    try {
      final ok = await _firestore.collection('messages/$roomId/messages').add({
        "from": from,
        "message": message,
        "time": time,
        "to": to,
        "read": read,
        "type": type,
      });

      final s = ok.toString().split("/");
      final s1 = s[s.length - 1].split(")")[0];

      return s1;
    } catch (e) {
      print(e);
      return "";
    }
  }

  static Future<bool> removeRoom(String roomId) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return false;

    try {
      await _firestore
          .collection('messages')
          .doc(roomId)
          .collection("messages")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      print("Delete Room: $roomId");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
