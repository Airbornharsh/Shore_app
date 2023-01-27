import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/models.dart';

class UnsignUser with ChangeNotifier {
  List<UnsignUserModel> _users = [];
  List<UnsignUserModel> _tempUsers = [];

  Future<List<UnsignUserModel>> loadUsers(String userName) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
        Uri.parse("$domainUri/api/unsignuser/get-users"),
        body: json.encode({"limit": 15, "userName": userName}),
      );

      var parsedUserBody = json.decode(res.body);

      _users.clear();
      await parsedUserBody.forEach((user) {
        UnsignUserModel newUser = UnsignUserModel(
          id: user["id"].toString(),
          name: user["name"].toString(),
          gender: user["gender"].toString(),
          userName: user["userName"].toString(),
          imgUrl: user["imgUrl"].toString(),
          joinedDate: user["joinedDate"].toString(),
          phoneNumber: user["phoneNumber"].toString(),
          posts: List<String>.from(user["posts"]),
          followers: List<String>.from(user["followers"]),
          followings: List<String>.from(user["followings"]),
        );

        _users.add(newUser);
      });

      _tempUsers = [..._users];
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return _users;
  }

  Future<UnsignUserModel> loadUser(String userId) async {
    late UnsignUserModel newUser;
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
        Uri.parse("$domainUri/api/unsignuser/get-user"),
        body: json.encode({"userId": userId}),
      );

      var parsedUserBody = json.decode(res.body);

      newUser = UnsignUserModel(
        id: parsedUserBody["id"].toString(),
        name: parsedUserBody["name"].toString(),
        gender: parsedUserBody["gender"].toString(),
        userName: parsedUserBody["userName"].toString(),
        imgUrl: parsedUserBody["imgUrl"].toString(),
        joinedDate: parsedUserBody["joinedDate"].toString(),
        phoneNumber: parsedUserBody["phoneNumber"].toString(),
        posts: List<String>.from(parsedUserBody["posts"]),
        followers: List<String>.from(parsedUserBody["followers"]),
        followings: List<String>.from(parsedUserBody["followings"]),
      );
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return newUser;
  }
}
