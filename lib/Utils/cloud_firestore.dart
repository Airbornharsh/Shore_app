import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shore_app/models.dart';

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

  static void sendMessage(
      {required String roomId,
      required String from,
      required String message,
      required int time,
      required String to,
      required bool read,
      required String type}) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) return;

    // await _firestore.collection('messages').doc(roomId).add({
    //   "from": from,
    //   "message": message,
    //   "time": time,
    //   "to": to,
    //   "read": read,
    //   "type": type,
    // });

    try {
      print("roomId: $roomId");

      await _firestore.collection('messages/$roomId/messages').add({
        "from": from,
        "message": message,
        "time": time,
        "to": to,
        "read": read,
        "type": type,
      });
    } catch (e) {
      print(e);
    }
  }

  // static Future<List<Message>> getMessages(String roomId) async {
  //   final _firestore = FirebaseFirestore.instance;
  //   final _auth = FirebaseAuth.instance;
  //   List<Message> messages = [];
  //   if (_auth.currentUser == null) return [];

  //   try {
  //     print("roomId: $roomId");

  //     final data = await _firestore
  //         .collection('messages/$roomId/messages')
  //         .orderBy("time", descending: true)
  //         .snapshots();

  //     // await data.forEach((element) async {
  //     //   print(element.docs.);
  //     //   // messages.add(Message(
  //     //   // from: element.docs["from"],
  //     //   // message: element.docs[0]["message"],
  //     //   // time: element.docs[0]["time"],
  //     //   // to: element.docs[0]["to"],
  //     //   // read: element.docs[0]["read"],
  //     //   // type: element.docs[0]["type"]));
  //     // });

  //     await data.forEach((element) async {
  //       element.docs.forEach((element) {
  //         final message = element.data();

  //         print(message["message"]);
  //         messages.add(Message(
  //             from: message["from"],
  //             message: message["message"],
  //             time: message["time"],
  //             to: message["to"],
  //             read: message["read"],
  //             type: message["type"]));

  //         print(messages);
  //       });
  //     });

  //     print("List");
  //     print(messages);

  //     return messages;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }
}
