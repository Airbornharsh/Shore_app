import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shore_app/Utils/Prefs.dart';
import 'package:shore_app/models.dart';

class Posts with ChangeNotifier {
  Future<List<PostModel>> loadPosts() async {
    List<PostModel> posts = [];
    var client = Client();

    String domainUri = Prefs.getString("shore_backend_uri");
    try {
      var postRes = await client.post(
        Uri.parse("$domainUri/api/post/get"),
        body: json.encode({"page": 1}),
      );

      var postResBody = json.decode(postRes.body);

      await postResBody.forEach((post) {
        PostModel newPost = PostModel(
            id: post["_id"].toString(),
            userId: post["userId"].toString(),
            description: post["description"].toString(),
            url: post["url"].toString(),
            profileUrl: post["profileUrl"].toString(),
            profileName: post["profileName"].toString(),
            profileUserName: post["profileUserName"].toString(),
            postedDate: post["postedDate"].toString(),
            likes: List<String>.from(post["likes"]),
            comments: List<String>.from(post["comments"]));

        posts.add(newPost);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return posts;
  }

  Future<List<PostModel>> loadNewPosts(int page) async {
    List<PostModel> posts = [];
    var client = Client();

    String domainUri = Prefs.getString("shore_backend_uri");
    try {
      var postRes = await client.post(
        Uri.parse("$domainUri/api/post/get"),
        body: json.encode({"page": 1}),
        headers: {"Content-Type": "application/json"}
      );

      var postResBody = json.decode(postRes.body);

      await postResBody.forEach((post) {
        PostModel newPost = PostModel(
            id: post["_id"].toString(),
            userId: post["userId"].toString(),
            description: post["description"].toString(),
            url: post["url"].toString(),
            profileUrl: post["profileUrl"].toString(),
            profileName: post["profileName"].toString(),
            profileUserName: post["profileUserName"].toString(),
            postedDate: post["postedDate"].toString(),
            likes: List<String>.from(post["likes"]),
            comments: List<String>.from(post["comments"]));

        posts.add(newPost);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return posts;
  }

  bool isUserLiked(List<String> postLikes, String id) {
    return postLikes.contains(id);
  }

  bool isUserFav(UserModel user, String id) {
    return user.fav.contains(id);
  }
}
