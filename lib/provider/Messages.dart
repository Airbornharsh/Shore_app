import 'package:flutter/material.dart';

// class MessagesModel {
//   String userId;
//   List<Message> messages;

//   MessagesModel({required this.messages, required this.userId});
// }

class Messages extends ChangeNotifier {
  // late Map<String, List<Message>> _messages = {};

  // void setMessages(Map<String, List<Message>> messages) {
  //   // Iterable<String> keys = messages.keys;

  //   // keys.forEach((key) {
  //   //   _messages.putIfAbsent(key, () => messages[key] as List<Message>);
  //   // });

  //   _messages = {...messages};

  //   print(_messages.length);
  // }

  // Future<List<UnsignUserModel>> loadFriendsUsers() async {
  //   var client = Client();
  //   final prefs = await SharedPreferences.getInstance();
  //   String domainUri = prefs.get("shore_backend_uri") as String;
  //   String? accessToken = prefs.getString("shore_accessToken");
  //   try {
  //     Response res = await client.post(
  //         Uri.parse("$domainUri/api/user/friends/message-list"),
  //          headers: {
  // "authorization": "Bearer $accessToken",
  // });

  //     var parsedUserBody = json.decode(res.body);

  //     if (res.statusCode != 200) {
  //       throw res.body;
  //     }

  //     _friends.clear();

  //     await parsedUserBody.forEach((user) {
  //       UnsignUserModel newUser = UnsignUserModel(
  //         id: user["id"].toString(),
  //         name: user["name"].toString(),
  //         gender: user["gender"].toString(),
  //         userName: user["userName"].toString(),
  //         imgUrl: user["imgUrl"].toString(),
  //         joinedDate: user["joinedDate"].toString(),
  //         phoneNumber: user["phoneNumber"].toString(),
  //         isPrivate: user["isPrivate"],
  //         socketIds: List<String>.from(user["socketIds"]),
  //         posts: List<String>.from(user["posts"]),
  //         followers: List<String>.from(user["followers"]),
  //         followings: List<String>.from(user["followings"]),
  //       );

  //       _friends.add(newUser);
  //     });
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     notifyListeners();
  //   }
  //   return _friends;
  // }
}
