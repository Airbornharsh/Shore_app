import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/models.dart';

class UnsignedUser with ChangeNotifier {
  List<UnsignedUserModel> _users = [];
  List<UnsignedUserModel> _tempUsers = [];

  Future<List<UnsignedUserModel>> loadUsers(String userName) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
        Uri.parse("$domainUri/api/unsignuser/get-user"),
        body: json.encode({"limit": 15, "userName": userName}),
      );

      var resBody = json.decode(res.body);

      _users.clear();
      await resBody.forEach((post) {
        UnsignedUserModel newUser = UnsignedUserModel(
          id: post["_id"].toString(),
          name: post["name"].toString(),
          userName: post["userName"].toString(),
          imgUrl: post["imgUrl"].toString(),
          joinedDate: post["joinedDate"].toString(),
          gender: post["gender"].toString(),
          phoneNumber: post["phoneNumber"].toString(),
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
}
