import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class Posts with ChangeNotifier {
  late List<PostModel> _posts = [];

  Future<bool> loadUserPosts() async {
    return true;
  }

  Future<bool> postUpload(File file, String description,
      String fileName, String destination) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final fileUrl = await fileUpload(file, destination);

      if (fileUrl == "") {
        return false;
      }

      print(fileUrl);

      final accessToken = prefs.get("shore_accessToken") as String;

      var postRes = await client.post(Uri.parse("$domainUri/api/user/post/add"),
          body: json.encode({"url": fileUrl, "description": description}),
          headers: {"authorization": "Bearer $accessToken"});

      var postResBody = json.decode(postRes.body);

      print(postResBody);

      

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future fileUpload(File file, String destination) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      final task = await ref.putFile(file);

      if (task == null) return "";

      final fileUrl = await task.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      print(e);
      return "";
    } finally {}
  }
}
