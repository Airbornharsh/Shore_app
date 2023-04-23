import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Utils/Functions.dart';
import 'package:shore_app/Utils/cloud_firestore.dart';
import 'package:shore_app/models.dart';

class SignUser with ChangeNotifier {
  UserModel _user = UserModel(
      id: "1",
      name: "",
      emailId: "",
      gender: "",
      userName: "",
      imgUrl: "",
      joinedDate: DateTime.now().toString(),
      phoneNumber: "000000000",
      emailIdFirebaseId: "",
      phoneNumberFirebaseId: "",
      isPrivate: false,
      posts: [],
      followers: [],
      followings: [],
      closeFriends: [],
      acceptedFollowerRequests: [],
      declinedFollowerRequests: [],
      requestingFollowers: [],
      acceptedFollowingRequests: [],
      declinedFollowingRequests: [],
      requestingFollowing: [],
      postLiked: [],
      commentLiked: [],
      commented: [],
      fav: []);

  List<UserPostModel> _userPosts = [];
  List<PostModel> _userLikedPosts = [];
  List<UnsignUserModel> _friends = [];
  Map<String, String> _friendRoomId = {};
  Map<String, List<Message>> _roomMessages = {};
  Map<String, List<Comment>> _postComments = {};

  // late String _accessToken;
  bool _isAuth = FirebaseAuth.instance.currentUser == null ? false : true;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await prefs.getString("shore_user_details");

    final parsedUserBody = json.decode(user!);

    _user = UserModel(
        id: parsedUserBody["_id"].toString(),
        name: parsedUserBody["name"].toString(),
        emailId: parsedUserBody["emailId"].toString(),
        gender: parsedUserBody["gender"].toString(),
        userName: parsedUserBody["userName"].toString(),
        imgUrl: parsedUserBody["imgUrl"].toString(),
        joinedDate: parsedUserBody["joinedDate"].toString(),
        phoneNumber: parsedUserBody["phoneNumber"].toString(),
        emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
        phoneNumberFirebaseId:
            parsedUserBody["phoneNumberFirebaseId"].toString(),
        isPrivate: parsedUserBody["isPrivate"],
        posts: List<String>.from(parsedUserBody["posts"]),
        followers: List<String>.from(parsedUserBody["followers"]),
        followings: List<String>.from(parsedUserBody["followings"]),
        closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
        acceptedFollowerRequests:
            List<String>.from(parsedUserBody["acceptedFollowerRequests"]),
        declinedFollowerRequests:
            List<String>.from(parsedUserBody["declinedFollowerRequests"]),
        requestingFollowers:
            List<String>.from(parsedUserBody["requestingFollowers"]),
        acceptedFollowingRequests:
            List<String>.from(parsedUserBody["acceptedFollowingRequests"]),
        declinedFollowingRequests:
            List<String>.from(parsedUserBody["declinedFollowingRequests"]),
        requestingFollowing:
            List<String>.from(parsedUserBody["requestingFollowing"]),
        postLiked: List<String>.from(parsedUserBody["postLiked"]),
        commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
        commented: List<String>.from(parsedUserBody["commented"]),
        fav: List<String>.from(parsedUserBody["fav"]));
  }

  bool get getIsAuth {
    return _isAuth;
  }

  UserModel get getUserDetails {
    return _user;
  }

  List<UnsignUserModel> get getFriends {
    return _friends;
  }

  UnsignUserModel getFriend(String userId) {
    return _friends.firstWhere((element) => element.id == userId);
  }

  Map<String, List<Message>> get getRoomMessages {
    return _roomMessages;
  }

  // Future<List<Message>?> getRoomMessage(String id) async {
  //   final messages =
  //       await cloud_firestore.getMessages(Functions.genHash(_user.id, id));

  //   print("Hii");
  //   return messages;
  // }

  Map<String, String> get getRoomIds {
    return _friendRoomId;
  }

  String getRoomId(String id) {
    return _friendRoomId[id]!;
  }

  List<Comment> getComments(String postId) {
    if (_postComments.containsKey(postId)) {
      return _postComments[postId]!;
    } else {
      return [];
    }
  }

  List<PostModel> get getUserLikedPosts {
    return _userLikedPosts;
  }

  void addMessage(Map<String, dynamic> message) {
    _roomMessages[Functions.genHash(message["senderUserId"], _user.id)]?.add(
        Message(
            from: message["senderUserId"].toString(),
            message: message["message"],
            time: int.parse(message["time"]),
            to: _user.id,
            type: message["type"].toString(),
            read: message["read"]));

    notifyListeners();
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance.signOut();
    // prefs.setString("shore_accessToken", "");
    _isAuth = false;
    _user = UserModel(
        id: "1",
        name: "",
        emailId: "",
        gender: "",
        userName: "",
        imgUrl: "",
        emailIdFirebaseId: "",
        phoneNumberFirebaseId: "",
        joinedDate: DateTime.now().toString(),
        phoneNumber: "000000000",
        isPrivate: false,
        posts: [],
        followers: [],
        followings: [],
        closeFriends: [],
        acceptedFollowerRequests: [],
        declinedFollowerRequests: [],
        requestingFollowers: [],
        acceptedFollowingRequests: [],
        declinedFollowingRequests: [],
        requestingFollowing: [],
        postLiked: [],
        commentLiked: [],
        commented: [],
        fav: []);
    notifyListeners();

    final deviceToken = await prefs.getString("shore_device_token") as String;
    final domainUri = await prefs.get("shore_backend_uri") as String;
    final accessToken = await prefs.get("shore_accessToken") as String;

    try {
      final client = Client();

      await client.post(Uri.parse("$domainUri/api/user/logout"),
          body: json.encode({
            "deviceToken": deviceToken,
          }),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      await prefs.remove("shore_accessToken");
    } catch (e) {
      print(e);
    }
  }

  Future<bool> onLoad() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      if (!prefs.containsKey("shore_accessToken")) {
        return false;
      }
      String accessToken = prefs.get("shore_accessToken") as String;

      if (accessToken.isEmpty) return false;

      var userRes =
          await client.get(Uri.parse("$domainUri/api/user/get"), headers: {
        "authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      });

      if (userRes.statusCode != 200) {
        throw userRes.body;
      }

      var parsedUserBody = json.decode(userRes.body);

      _isAuth = true;

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId:
              parsedUserBody["phoneNumberFirebaseId"].toString(),
          isPrivate: parsedUserBody["isPrivate"],
          posts: List<String>.from(parsedUserBody["posts"]),
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          acceptedFollowerRequests:
              List<String>.from(parsedUserBody["acceptedFollowerRequests"]),
          declinedFollowerRequests:
              List<String>.from(parsedUserBody["declinedFollowerRequests"]),
          requestingFollowers:
              List<String>.from(parsedUserBody["requestingFollowers"]),
          acceptedFollowingRequests:
              List<String>.from(parsedUserBody["acceptedFollowingRequests"]),
          declinedFollowingRequests:
              List<String>.from(parsedUserBody["declinedFollowingRequests"]),
          requestingFollowing:
              List<String>.from(parsedUserBody["requestingFollowing"]),
          postLiked: List<String>.from(parsedUserBody["postLiked"]),
          commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
          commented: List<String>.from(parsedUserBody["commented"]),
          fav: List<String>.from(parsedUserBody["fav"]));

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<UserModel> reloadUser() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      var userRes =
          await client.get(Uri.parse("$domainUri/api/user/get"), headers: {
        "authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      });

      if (userRes.statusCode != 200) {
        throw userRes.body;
      }

      var parsedUserBody = json.decode(userRes.body);

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId:
              parsedUserBody["phoneNumberFirebaseId"].toString(),
          isPrivate: parsedUserBody["isPrivate"],
          posts: List<String>.from(parsedUserBody["posts"]),
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          acceptedFollowerRequests:
              List<String>.from(parsedUserBody["acceptedFollowerRequests"]),
          declinedFollowerRequests:
              List<String>.from(parsedUserBody["declinedFollowerRequests"]),
          requestingFollowers:
              List<String>.from(parsedUserBody["requestingFollowers"]),
          acceptedFollowingRequests:
              List<String>.from(parsedUserBody["acceptedFollowingRequests"]),
          declinedFollowingRequests:
              List<String>.from(parsedUserBody["declinedFollowingRequests"]),
          requestingFollowing:
              List<String>.from(parsedUserBody["requestingFollowing"]),
          postLiked: List<String>.from(parsedUserBody["postLiked"]),
          commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
          commented: List<String>.from(parsedUserBody["commented"]),
          fav: List<String>.from(parsedUserBody["fav"]));

      return _user;
    } catch (e) {
      print(e);
      return _user;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> signIn(String authDetail, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    String authType = "";
    String deviceToken = prefs.getString("shore_device_token") as String;

    try {
      String emailPattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp emailRegex = RegExp(emailPattern);
      String phoneNumberPatttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp phoneNumberRegExp = RegExp(phoneNumberPatttern);

      if (emailRegex.hasMatch(authDetail)) {
        authType = "emailId";
      } else if (phoneNumberRegExp.hasMatch(authDetail)) {
        authType = "phoneNumber";
      } else {
        authType = "userName";
      }

      var tokenRes = await client.post(Uri.parse("$domainUri/api/user/login"),
          body: json.encode({
            authType: authDetail,
            "password": password,
            "deviceToken": deviceToken
          }),
          // body: json.encode({
          //   "emailId": "harshkeshri1234567@gmail.com",
          //   "password": "Password1!"
          // }),
          headers: {"Content-Type": "application/json"});

      if (tokenRes.statusCode != 200) {
        throw tokenRes.body;
      }

      var parsedBody = json.decode(tokenRes.body);
      prefs.setString("shore_accessToken", parsedBody["accessToken"]);
      final accessToken = parsedBody["accessToken"];

      _isAuth = true;
      var userRes =
          await client.get(Uri.parse("$domainUri/api/user/get"), headers: {
        "authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      });

      if (userRes.statusCode != 200) {
        return json.decode(userRes.body)["message"];
      }

      var parsedUserBody = json.decode(userRes.body);

      prefs.setString("shore_user_details", json.encode(parsedUserBody));

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId:
              parsedUserBody["phoneNumberFirebaseId"].toString(),
          isPrivate: parsedUserBody["isPrivate"],
          posts: List<String>.from(parsedUserBody["posts"]),
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          acceptedFollowerRequests:
              List<String>.from(parsedUserBody["acceptedFollowerRequests"]),
          declinedFollowerRequests:
              List<String>.from(parsedUserBody["declinedFollowerRequests"]),
          requestingFollowers:
              List<String>.from(parsedUserBody["requestingFollowers"]),
          acceptedFollowingRequests:
              List<String>.from(parsedUserBody["acceptedFollowingRequests"]),
          declinedFollowingRequests:
              List<String>.from(parsedUserBody["declinedFollowingRequests"]),
          requestingFollowing:
              List<String>.from(parsedUserBody["requestingFollowing"]),
          postLiked: List<String>.from(parsedUserBody["postLiked"]),
          commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
          commented: List<String>.from(parsedUserBody["commented"]),
          fav: List<String>.from(parsedUserBody["fav"]));

      return "Done";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> isValidAccessToken() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    final domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;
    final deviceToken = await prefs.getString("shore_device_token") as String;

    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/user/is-valid-user"),
          body: json.encode({"deviceToken": deviceToken}),
          headers: {
            "Content-Type": "application/json",
            "authorization": "Bearer $accessToken"
          });

      var parsedBody = json.decode(res.body);

      var parsedUserBody = parsedBody["user"];

      if (res.statusCode != 200) {
        return false;
      }

      prefs.setString("shore_user_details", json.encode(parsedUserBody));

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          emailIdFirebaseId: parsedUserBody["emailIdFirebaseId"].toString(),
          phoneNumberFirebaseId:
              parsedUserBody["phoneNumberFirebaseId"].toString(),
          isPrivate: parsedUserBody["isPrivate"],
          posts: List<String>.from(parsedUserBody["posts"]),
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          acceptedFollowerRequests:
              List<String>.from(parsedUserBody["acceptedFollowerRequests"]),
          declinedFollowerRequests:
              List<String>.from(parsedUserBody["declinedFollowerRequests"]),
          requestingFollowers:
              List<String>.from(parsedUserBody["requestingFollowers"]),
          acceptedFollowingRequests:
              List<String>.from(parsedUserBody["acceptedFollowingRequests"]),
          declinedFollowingRequests:
              List<String>.from(parsedUserBody["declinedFollowingRequests"]),
          requestingFollowing:
              List<String>.from(parsedUserBody["requestingFollowing"]),
          postLiked: List<String>.from(parsedUserBody["postLiked"]),
          commentLiked: List<String>.from(parsedUserBody["commentLiked"]),
          commented: List<String>.from(parsedUserBody["commented"]),
          fav: List<String>.from(parsedUserBody["fav"]));

      _isAuth = true;

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> signUp(
      String name,
      String userName,
      int phoneNumber,
      String emailId,
      String password,
      String confirmPasssword,
      String emailIdFirebaseId,
      String phoneNumberFirebaseId,
      PhoneAuthCredential phoneAuthCredential) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    String deviceToken = prefs.get("shore_device_token") as String;

    if (password != confirmPasssword) {
      return "Password are Different";
    }

    try {
      var res = await client.post(Uri.parse("$domainUri/api/user/register"),
          body: json.encode({
            "name": name,
            "phoneNumber": phoneNumber,
            "userName": userName.toLowerCase().trim(),
            "emailId": emailId,
            "password": password,
            "deviceToken": deviceToken,
            "emailIdFirebaseId": emailIdFirebaseId,
            "phoneNumberFirebaseId": phoneNumberFirebaseId
          }),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailId, password: password);

      debugPrint("Started Updating");

      await credential.user!.updateDisplayName(userName.toString());

      debugPrint("Updated Display Name");
      // var parsedBody = json.decode(res.body);

      cloud_firestore.createUser(name, phoneNumber);

      return "Done";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> postUpload(String isFile, File file, String description,
      String fileName, String destination) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final fileUrl =
          isFile == "image" ? await fileUpload(file, destination) : "";

      if (fileUrl == "") {
        return false;
      }

      final accessToken = prefs.get("shore_accessToken") as String;

      var postRes = await client.post(Uri.parse("$domainUri/api/user/post/add"),
          body: json.encode({"url": fileUrl, "description": description}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

      // var postResBody = json.decode(postRes.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  // files/63ce582198aafbd60d76f6be/IMG-20230124-WA0003_compressed6825376798441975810.jpg_2023-01-25 20:25:51.726868

  Future<String> fileUpload(File file, String destination) async {
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

  Future<bool> postLike(String postId) async {
    notifyListeners();
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/post/like/add"),
          body: json.encode({"postId": postId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> postUnlike(String postId) async {
    notifyListeners();
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/post/like/remove"),
          body: json.encode({"postId": postId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> postAddFav(String postId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(Uri.parse("$domainUri/api/user/post/fav/add"),
          body: json.encode({"postId": postId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> postRemoveFav(String postId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/post/fav/remove"),
          body: json.encode({"postId": postId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<List<UserPostModel>> loadUserPosts() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var postRes = await client
          .post(Uri.parse("$domainUri/api/user/post/get"), headers: {
        "authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      });

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

      var postResBody = json.decode(postRes.body);

      _userPosts.clear();
      await postResBody.forEach((post) {
        UserPostModel newPost = UserPostModel(
            id: post["_id"].toString(),
            userId: post["userId"].toString(),
            description: post["description"].toString(),
            url: post["url"].toString(),
            postedDate: post["postedDate"].toString(),
            likes: List<String>.from(post["likes"]),
            comments: List<String>.from(post["comments"]));

        _userPosts.add(newPost);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return _userPosts;
  }

  Future<String> editProfile(
      {required String name,
      required String gender,
      required String userName,
      required String emailId,
      required String phoneNumber}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      Map<String, String> data = {
        "name": "",
        "gender": "",
        "userName": "",
        "emailId": "",
        "phoneNumber": ""
      };

      if (name.trim() != _user.name) {
        data["name"] = name;
      }

      if (gender.trim() != _user.gender) {
        data["gender"] = gender;
      }

      if (userName.trim() != _user.userName) {
        data["userName"] = userName.toLowerCase().trim();
      }

      if (emailId.trim() != _user.emailId) {
        data["emailId"] = emailId;
      }

      if (phoneNumber.trim() != _user.phoneNumber) {
        data["phoneNumber"] = phoneNumber;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/edit"),
          body: json.encode(data),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      await reloadUser();

      return "withoutImg";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      notifyListeners();
    }
  }

  Future<String> editProfileWithImg(
      {required File file,
      required String fileName,
      required String destination,
      required String name,
      required String gender,
      required String userName,
      required String emailId,
      required String phoneNumber}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      String imgUrl =
          file.path.isNotEmpty ? await fileUpload(file, destination) : "";

      Map<String, String> data = {
        "imgUrl": file.path.isNotEmpty ? imgUrl : _user.imgUrl,
        "name": "",
        "gender": "",
        "userName": "",
        "emailId": "",
        "phoneNumber": ""
      };

      if (name.trim() != _user.name) {
        data["name"] = name;
      }

      if (gender.trim() != _user.gender) {
        data["gender"] = gender;
      }

      if (userName.trim() != _user.userName) {
        data["userName"] = userName.toLowerCase().trim();
      }

      if (emailId.trim() != _user.emailId) {
        data["emailId"] = emailId;
      }

      if (phoneNumber.trim() != _user.phoneNumber) {
        data["phoneNumber"] = phoneNumber;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/edit"),
          body: json.encode(data),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      if (_user.imgUrl.isNotEmpty) {
        final tempdestination = _user.imgUrl
            .split("?alt")[0]
            .split("appspot.com/o/")[1]
            .replaceAll("%2F", "/");

        final ref = FirebaseStorage.instance.ref(tempdestination);

        await ref.delete();
      }

      await reloadUser();

      return "withImg";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      notifyListeners();
    }
  }

  Future<String> editPost(
      {required String description, required UserPostModel post}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      Map<String, String> data = {
        "description": "",
      };

      if (description.trim() != post.description) {
        data["description"] = description;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/post/edit"),
          body: json.encode(data),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      return "withoutImg";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      notifyListeners();
    }
  }

  Future<String> editPostWithImg(
      {required File file,
      required String fileName,
      required String destination,
      required String description,
      required UserPostModel post}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      String imgUrl =
          file.path.isNotEmpty ? await fileUpload(file, destination) : "";

      Map<String, String> data = {
        "url": file.path.isNotEmpty ? imgUrl : post.url,
        "description": "",
        "postId": post.id
      };

      if (description.trim() != post.description) {
        data["description"] = description;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/post/edit"),
          body: json.encode(data),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      final tempdestination = post.url
          .split("?alt")[0]
          .split("appspot.com/o/")[1]
          .replaceAll("%2F", "/");

      final ref = FirebaseStorage.instance.ref(tempdestination);

      await ref.delete();

      return "withImg";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      notifyListeners();
    }
  }

  Future<String> deletePost(
      {required String description, required UserPostModel post}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      Map<String, String> data = {"postId": post.id};

      var res = await client.post(Uri.parse("$domainUri/api/user/post/delete"),
          body: json.encode(data),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      final tempdestination = post.url
          .split("?alt")[0]
          .split("appspot.com/o/")[1]
          .replaceAll("%2F", "/");

      final ref = FirebaseStorage.instance.ref(tempdestination);

      await ref.delete();

      return "withImg";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      notifyListeners();
    }
  }

  String isFollowing(String userId) {
    bool res;
    if (_user.followings.isNotEmpty) {
      res = _user.followings.contains(userId);

      if (res) {
        return "Following";
      }
    }

    if (_user.requestingFollowing.isNotEmpty) {
      res = _user.requestingFollowing.contains(userId);
      if (res) {
        return "Requested";
      } else {
        return "Follow";
      }
    } else {
      return "Follow";
    }
  }

  Future<String> follow(String userId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/unsign-user/follow"),
          body: json.encode({"userId": userId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

      if (resBody["message"] == "Requested") {
        _user.requestingFollowing.add(userId);
      } else {
        _user.followings.add(userId);
      }

      return resBody["message"];
    } catch (e) {
      print(e);
      return "Server Error";
    } finally {
      notifyListeners();
    }
  }

  Future<bool> unfollow(String userId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/unsign-user/unfollow"),
          body: json.encode({"userId": userId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      _user.followings.remove(userId);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<List<UnsignUserModel>> loadFollowingsUsers(
      {required String userId}) async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      Response res;

      userId.isEmpty
          ? res = await client.post(
              Uri.parse("$domainUri/api/user/followings/list"),
              headers: {"authorization": "Bearer $accessToken"})
          : res = await client.post(
              Uri.parse("$domainUri/api/unsignuser/followings/list"),
              body: json.encode({"userId": userId}),
              headers: {
                  "authorization": "Bearer $accessToken",
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

  Future<List<UnsignUserModel>> loadFollowersUsers(
      {required String userId}) async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      Response res;

      userId.isEmpty
          ? res = await client.post(
              Uri.parse("$domainUri/api/user/followers/list"),
              headers: {"authorization": "Bearer $accessToken"})
          : res = await client.post(
              Uri.parse("$domainUri/api/unsignuser/followers/list"),
              body: json.encode({"userId": userId}),
              headers: {
                  "authorization": "Bearer $accessToken",
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
      print("Error in loadFollowersUsers");
      print(e);
    } finally {
      notifyListeners();
    }
    return users;
  }

  Future<List<UnsignUserModel>> loadFriendsUsers() async {
    // Map<String, List<Message>> messages = {};
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      Response res = await client.post(
          Uri.parse("$domainUri/api/user/friends/message-list"),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      var parsedUserBody = json.decode(res.body);

      if (res.statusCode != 200) {
        throw res.body;
      }

      _friends.clear();
      _roomMessages.clear();
      _friendRoomId.clear();

      await parsedUserBody.forEach((user) {
        String roomId = Functions.genHash(user["id"], _user.id);

        _friendRoomId.putIfAbsent(
          user["id"],
          () => roomId,
        );
        user["messages"].forEach((message) {
          if (_roomMessages.containsKey(roomId)) {
            _roomMessages[roomId]?.add(Message(
                from: message["from"],
                message: message["message"],
                time: int.parse(message["time"]),
                to: message["to"],
                read: message["read"],
                type: message["type"]));
          } else {
            _roomMessages.putIfAbsent(
                roomId.toString(),
                () => [
                      Message(
                          from: message["from"],
                          message: message["message"],
                          time: int.parse(message["time"]),
                          to: message["to"],
                          read: message["read"],
                          type: message["type"])
                    ]);
          }
        });

        if (user["messages"].length == 0) {
          _roomMessages.putIfAbsent(roomId.toString(), () => []);
        }

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

        _friends.add(newUser);
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return _friends;
  }

  Future<List<UnsignUserModel>> loadRequestingFollowers() async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/user/requesting/list"), headers: {
        "authorization": "Bearer $accessToken",
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

  Future<bool> acceptFollowRequest(String userId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/requesting/accept"),
          body: json.encode({"userId": userId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      _user.acceptedFollowerRequests.add(userId);
      _user.followers.add(userId);
      _user.requestingFollowers.remove(userId);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> declineFollowRequest(String userId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/requesting/decline"),
          body: json.encode({"userId": userId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      // var resBody = json.decode(res.body);

      _user.declinedFollowingRequests.add(userId);
      _user.followers.add(userId);
      _user.requestingFollowers.remove(userId);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<List<UnsignUserModel>> loadRequestingFollowing() async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    final accessToken = prefs.getString("shore_accessToken") as String;

    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/user/requested/list"), headers: {
        "authorization": "Bearer $accessToken",
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

  Future<bool> sendMessage(String recieverUserId, String message,
      ScrollController scrollController, int currentTime) async {
    final roomId = Functions.genHash(recieverUserId, _user.id);
    // if (_roomMessages.containsKey(roomId)) {
    //   _roomMessages[roomId]?.add(Message(
    //       from: _user.id.toString(),
    //       message: message,
    //       time: currentTime,
    //       to: recieverUserId,
    //       read: false,
    //       type: "text"));
    // } else {
    //   // _roomMessages.putIfAbsent(
    //   //     roomId.toString(),
    //   //     () => [
    //   //           Message(
    //   //               from: _user.id.toString(),
    //   //               message: message,
    //   //               time: int.parse(currentTime),
    //   //               to: recieverUserId,
    //   //               read: false,
    //   //               type: "text")
    //   //         ]);

    //   _roomMessages[roomId] = [
    //     Message(
    //         from: _user.id.toString(),
    //         message: message,
    //         time: currentTime,
    //         to: recieverUserId,
    //         read: false,
    //         type: "text")
    //   ];
    // }

    notifyListeners();

    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );

    cloud_firestore.sendMessage(
        roomId: roomId,
        from: _user.id.toString(),
        message: message,
        time: currentTime,
        to: recieverUserId,
        read: false,
        type: "text");

    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    final fcm = await FirebaseMessaging.instance;
    final domainUri = await prefs.get("shore_backend_uri") as String;
    final accessToken = await prefs.get("shore_accessToken") as String;
    try {
      print("Sending");

      // fcm.

      await client.post(Uri.parse("$domainUri/api/user/message/one"),
          body: json.encode({
            "recieverUserId": recieverUserId,
            "message": message,
            "currentTime": currentTime,
            "type": "text"
          }),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      print("Send");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future loadComments(String postId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    final domainUri = await prefs.get("shore_backend_uri") as String;
    final accessToken = await prefs.get("shore_accessToken") as String;
    try {
      Response res = await client.post(
          Uri.parse("$domainUri/api/user/post/comment/get/post-render"),
          body: json.encode({"postId": postId}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      var parsedBody = json.decode(res.body);

      if (res.statusCode != 200) {
        throw parsedBody["message"];
      }

      // Comment comment = Comment(
      //     id: parsedBody["_id"],
      //     description: parsedBody["description"],
      //     reply: parsedBody["reply"] == null ? "" : parsedBody["reply"],
      //     commented: parsedBody["commented"],
      //     likes: List<String>.from(parsedBody["likes"]),
      //     to: parsedBody["to"],
      //     postId: parsedBody["postId"],
      //     time: parsedBody["time"]);

      // _user.commented.add(parsedBody["_id"]);

      _postComments.clear();

      parsedBody.forEach((comment) {
        Comment newComment = Comment(
            id: comment["_id"],
            description: comment["description"],
            reply: comment["reply"] == null ? "" : comment["reply"],
            commented: comment["commented"],
            likes: List<String>.from(comment["likes"]),
            to: comment["to"],
            postId: comment["postId"],
            imgUrl: comment["imgUrl"],
            name: comment["name"],
            userName: comment["userName"],
            time: comment["time"]);

        if (_postComments.containsKey(postId)) {
          _postComments[postId]?.add(newComment);
        } else {
          _postComments.putIfAbsent(postId, () => [newComment]);
        }
      });

      // if (_postComments.containsKey(postId)) {
      //   _postComments[postId]?.add(comment);
      // } else {
      //   _postComments.putIfAbsent(postId, () => [comment]);
      // }

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> sendComment(String postId, String description) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    final domainUri = await prefs.get("shore_backend_uri") as String;
    final accessToken = await prefs.get("shore_accessToken") as String;
    try {
      Response res = await client.post(
          Uri.parse("$domainUri/api/user/post/comment/add"),
          body: json.encode(
              {"postId": postId, "description": description, "reply": ""}),
          headers: {
            "authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          });

      var parsedBody = json.decode(res.body);

      if (res.statusCode != 200) {
        throw parsedBody["message"];
      }

      Comment comment = Comment(
          id: parsedBody["_id"],
          description: parsedBody["description"],
          reply: parsedBody["reply"] == null ? "" : parsedBody["reply"],
          commented: parsedBody["commented"],
          likes: List<String>.from(parsedBody["likes"]),
          to: parsedBody["to"],
          postId: parsedBody["postId"],
          imgUrl: _user.imgUrl,
          name: _user.name,
          userName: _user.userName,
          time: parsedBody["time"]);

      _user.commented.insert(0, parsedBody["_id"]);

      if (_postComments.containsKey(postId)) {
        _postComments[postId]?.insert(0, comment);
      } else {
        _postComments.putIfAbsent(postId, () => [comment]);
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> getLikedPosts() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    final domainUri = await prefs.get("shore_backend_uri") as String;
    final accessToken = await prefs.get("shore_accessToken") as String;
    try {
      Response res = await client
          .post(Uri.parse("$domainUri/api/user/liked/post/list"), headers: {
        "authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      });

      var parsedBody = json.decode(res.body);

      if (res.statusCode != 200) {
        throw parsedBody["message"];
      }

      _userLikedPosts.clear();
      await parsedBody.forEach((post) {
        PostModel newPost = PostModel(
            id: post["_id"].toString(),
            userId: post["userId"].toString(),
            description: post["description"].toString(),
            url: post["url"].toString(),
            postedDate: post["postedDate"].toString(),
            profileName: post["profileName"].toString(),
            profileUrl: post["profileUrl"].toString(),
            profileUserName: post["profileUserName"].toString(),
            likes: List<String>.from(post["likes"]),
            comments: List<String>.from(post["comments"]));

        _userLikedPosts.add(newPost);
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }
}
