import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/models.dart';

class User with ChangeNotifier {
  UserModel _user = UserModel(
      id: "69",
      name: "Harsh",
      emailId: "admin@example.com",
      gender: "Male",
      userName: "airbornharsh",
      imgUrl: "",
      joinedDate: DateTime.now().toString(),
      phoneNumber: "000000000",
      posts: [],
      friends: [],
      closeFriends: [],
      requestedFriends: [],
      requestingFriends: [],
      postLiked: [],
      commentLiked: [],
      commented: [],
      fav: []);
  
  
  late String _accessToken;
  late bool _isAuth = false;

  bool get getIsAuth {
    return _isAuth;
  }

  UserModel get getUserDetails {
    return _user;
  }

  void logout() {}

  Future<bool> signIn(String emailId, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var tokenRes = await client.post(Uri.parse("$domainUri/api/user/login"),
          body: json.encode({"emailId": emailId, "password": password}),
          headers: {"Content-Type": "application/json"});

      if (tokenRes.statusCode != 200) {
        throw tokenRes.body;
      }

      var parsedBody = json.decode(tokenRes.body);
      prefs.setString("shore_accessToken", parsedBody["accessToken"]);
      _accessToken = parsedBody["accessToken"];
      _isAuth = true;
      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $_accessToken"});

      var parsedUserBody = json.decode(userRes.body);

      print(parsedUserBody);

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          posts: List<String>.from(parsedUserBody["posts"]),
          friends: List<String>.from(parsedUserBody["friends"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          requestedFriends:
              List<String>.from(parsedUserBody["requestedFriends"]),
          requestingFriends: List<Map<String, dynamic>>.from(
              parsedUserBody["requestingFriends"]),
          postLiked: List<String>.from(parsedUserBody["postLiked"]),
          commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
          commented: List<String>.from(parsedUserBody["commented"]),
          fav: List<String>.from(parsedUserBody["fav"]));

      // _name = parsedUserBody["name"];
      // _phoneNumber = parsedUserBody["phoneNumber"];
      // _emailId = parsedUserBody["emailId"];
      // _orders = parsedUserBody["orders"];
      // _address = parsedUserBody["address"];
      // _createdAt = parsedUserBody["createdAt"];
      // _imgUrl = parsedUserBody["imgUrl"];
      // _shopkeeper = parsedUserBody["shopkeeper"];

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> signUp(
    String name,
    String userName,
    int phoneNumber,
    String emailId,
    String password,
    String confirmPasssword,
  ) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    if (password != confirmPasssword) {
      return false;
    }
    try {
      var res = await client.post(Uri.parse("$domainUri/api/user/register"),
          body: json.encode({
            "name": name,
            "phoneNumber": phoneNumber,
            "userName": userName,
            "emailId": emailId,
            "password": password
          }),
          headers: {"Content-Type": "application/json"});
      if (res.statusCode != 200) {
        return false;
      }
      var parsedBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }
}
