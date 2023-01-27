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

  Future<UnsignUserModel> reloadUser(String userId) async {
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

      print(parsedUserBody);

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

  Future<List<UserPostModel>> loadUnsignUserPosts(String userId) async {
    List<UserPostModel> unsignUserPosts = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var postRes = await client.post(
          Uri.parse("$domainUri/api/unsignuser/post/list"),
          body: json.encode({"userId": userId}),
          headers: {"authorization": "Bearer $accessToken"});

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

      var postResBody = json.decode(postRes.body);

      print(postResBody);

      await postResBody.forEach((post) {
        UserPostModel newPost = UserPostModel(
            id: post["_id"].toString(),
            userId: post["userId"].toString(),
            description: post["description"].toString(),
            url: post["url"].toString(),
            postedDate: post["postedDate"].toString(),
            likes: List<String>.from(post["likes"]),
            comments: List<String>.from(post["comments"]));

        unsignUserPosts.add(newPost);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return unsignUserPosts;
  }
}
