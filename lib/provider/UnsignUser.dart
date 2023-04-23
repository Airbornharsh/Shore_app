import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/models.dart';

class UnsignUser with ChangeNotifier {
  Future<List<UnsignUserModel>> loadUsers(String userName, int page) async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/unsignuser/get-users"),
          body: json.encode({"limit": 15, "userName": userName, "page": page}),
          headers: {
            "Content-Type": "application/json",
          });

      var parsedUserBody = json.decode(res.body);

      await parsedUserBody.forEach((user) {
        UnsignUserModel newUser = UnsignUserModel(
          id: user["id"].toString(),
          name: user["name"].toString(),
          gender: user["gender"].toString(),
          userName: user["userName"].toString(),
          imgUrl: user["imgUrl"].toString(),
          joinedDate: user["joinedDate"].toString(),
          phoneNumber: user["phoneNumber"].toString(),
          emailId: user["emailId"].toString(),
          emailIdFirebaseId: user["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId: user["phoneNumberFirebaseId"].toString(),
          isPrivate: user["isPrivate"],
          deviceTokens: List<String>.from(user["deviceTokens"]),
          posts: List<String>.from(user["posts"]),
          followers: List<String>.from(user["followers"]),
          followings: List<String>.from(user["followings"]),
        );

        users.add(newUser);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return users;
  }

  Future<List<UnsignUserModel>> loadMoreUsers(String userName, int page) async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/unsignuser/get-users"),
          body: json.encode({"limit": 15, "userName": userName, "page": page}),
          headers: {
            "Content-Type": "application/json",
          });

      var parsedUserBody = json.decode(res.body);

      await parsedUserBody.forEach((user) {
        UnsignUserModel newUser = UnsignUserModel(
          id: user["id"].toString(),
          name: user["name"].toString(),
          gender: user["gender"].toString(),
          userName: user["userName"].toString(),
          imgUrl: user["imgUrl"].toString(),
          joinedDate: user["joinedDate"].toString(),
          phoneNumber: user["phoneNumber"].toString(),
          emailId: user["emailId"].toString(),
          emailIdFirebaseId: user["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId: user["phoneNumberFirebaseId"].toString(),
          isPrivate: user["isPrivate"],
          deviceTokens: List<String>.from(user["deviceTokens"]),
          posts: List<String>.from(user["posts"]),
          followers: List<String>.from(user["followers"]),
          followings: List<String>.from(user["followings"]),
        );

        users.add(newUser);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return users;
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
          headers: {
            "Content-Type": "application/json",
          });

      var parsedUserBody = json.decode(res.body);

      newUser = await UnsignUserModel(
        id: parsedUserBody["id"].toString(),
        name: parsedUserBody["name"].toString(),
        gender: parsedUserBody["gender"].toString(),
        userName: parsedUserBody["userName"].toString(),
        imgUrl: parsedUserBody["imgUrl"].toString(),
        joinedDate: parsedUserBody["joinedDate"].toString(),
        phoneNumber: parsedUserBody["phoneNumber"].toString(),
        emailId: parsedUserBody["emailId"].toString(),
        emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
        phoneNumberFirebaseId:
            parsedUserBody["phoneNumberFirebaseId"].toString(),
        isPrivate: parsedUserBody["isPrivate"],
        deviceTokens: List<String>.from(parsedUserBody["deviceTokens"] ?? []),
        posts: List<String>.from(parsedUserBody["posts"] ?? []),
        followers: List<String>.from(parsedUserBody["followers"] ?? []),
        followings: List<String>.from(parsedUserBody["followings"] ?? []),
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
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

      var postResBody = json.decode(postRes.body);

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
