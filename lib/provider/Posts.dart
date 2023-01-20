import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class Posts with ChangeNotifier {
  late List<PostModel> _posts = [];

  Future<bool> loadUserPosts() async {
    return true;
  }

  Future<bool> postUpload(File file, UserModel user) async {
    try {
      final fileUrl = await fileUpload(file, user);

      if (fileUrl == "") {
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future fileUpload(File file, UserModel user) async {
    final fileName =
        "${file.path.split('/').last}_${DateTime.now().toString()}";
    final destination = "files/${user.id}/$fileName";
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
