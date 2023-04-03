import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  late String _accessToken;
  late bool _isAuth = false;

  bool get getIsAuth {
    return _isAuth;
  }

  UserModel get getUserDetails {
    return _user;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("shore_accessToken", "");
    _accessToken = "";
    _isAuth = false;
    _user = UserModel(
        id: "1",
        name: "",
        emailId: "",
        gender: "",
        userName: "",
        imgUrl: "",
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
      _accessToken = accessToken;

      if (accessToken.isEmpty) return false;

      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $accessToken"});

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

    try {
      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $_accessToken"});

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
    String deviceToken = prefs.getString("shore_app_token") as String;

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
      _accessToken = parsedBody["accessToken"];
      _isAuth = true;
      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $_accessToken"});

      if (userRes.statusCode != 200) {
        return json.decode(userRes.body)["message"];
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
    String domainUri = prefs.get("shore_backend_uri") as String;
    String accessToken = prefs.getString("shore_accessToken") as String;

    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/user/is-valid-user"),
          body: json.encode({}),
          headers: {
            "Content-Type": "application/json",
            "authorization": "Bearer $accessToken"
          });

      var parsedBody = json.decode(res.body);

      var parsedUserBody = parsedBody["user"];

      if (res.statusCode != 200) {
        return false;
      }

      _user = UserModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          gender: parsedUserBody["gender"].toString(),
          userName: parsedUserBody["userName"].toString(),
          imgUrl: parsedUserBody["imgUrl"].toString(),
          joinedDate: parsedUserBody["joinedDate"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
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
  ) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    String deviceToken = prefs.get("shore_app_token") as String;

    if (password != confirmPasssword) {
      return "Password are Different";
    }

    try {
      var res = await client.post(Uri.parse("$domainUri/api/user/register"),
          body: json.encode({
            "name": name,
            "phoneNumber": phoneNumber,
            "userName": userName,
            "emailId": emailId,
            "password": password,
            "deviceToken": deviceToken
          }),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode != 200) {
        return json.decode(res.body)["message"];
      }

      var parsedBody = json.decode(res.body);

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
          headers: {"authorization": "Bearer $accessToken"});

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

      var postResBody = json.decode(postRes.body);

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
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/post/like/add"),
          body: json.encode({"postId": postId}),
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> postUnlike(String postId) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      final accessToken = prefs.get("shore_accessToken") as String;

      var res = await client.post(
          Uri.parse("$domainUri/api/user/post/like/remove"),
          body: json.encode({"postId": postId}),
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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

      var postRes = await client.post(Uri.parse("$domainUri/api/user/post/get"),
          headers: {"authorization": "Bearer $accessToken"});

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
        data["userName"] = userName;
      }

      if (emailId.trim() != _user.emailId) {
        data["emailId"] = emailId;
      }

      if (phoneNumber.trim() != _user.phoneNumber) {
        data["phoneNumber"] = phoneNumber;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/edit"),
          body: json.encode(data),
          headers: {"authorization": "Bearer $accessToken"});

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
        data["userName"] = userName;
      }

      if (emailId.trim() != _user.emailId) {
        data["emailId"] = emailId;
      }

      if (phoneNumber.trim() != _user.phoneNumber) {
        data["phoneNumber"] = phoneNumber;
      }

      var res = await client.post(Uri.parse("$domainUri/api/user/edit"),
          body: json.encode(data),
          headers: {"authorization": "Bearer $accessToken"});

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
          headers: {"authorization": "Bearer $accessToken"});

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
          headers: {"authorization": "Bearer $accessToken"});

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
          headers: {"authorization": "Bearer $accessToken"});

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
          headers: {"authorization": "Bearer $accessToken"});

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
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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
    try {
      Response res;

      userId.isEmpty
          ? res = await client.post(
              Uri.parse("$domainUri/api/user/followings/list"),
              headers: {"authorization": "Bearer $_accessToken"})
          : res = await client.post(
              Uri.parse("$domainUri/api/unsignuser/followings/list"),
              body: json.encode({"userId": userId}),
              headers: {"authorization": "Bearer $_accessToken"});

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
          isPrivate: user["isPrivate"],
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
    try {
      Response res;

      userId.isEmpty
          ? res = await client.post(
              Uri.parse("$domainUri/api/user/followers/list"),
              headers: {"authorization": "Bearer $_accessToken"})
          : res = await client.post(
              Uri.parse("$domainUri/api/unsignuser/followers/list"),
              body: json.encode({"userId": userId}),
              headers: {"authorization": "Bearer $_accessToken"});

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
          isPrivate: user["isPrivate"],
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

  Future<List<UnsignUserModel>> loadRequestingFollowers() async {
    List<UnsignUserModel> users = [];
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/user/requesting/list"),
          headers: {"authorization": "Bearer $_accessToken"});
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
          isPrivate: user["isPrivate"],
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
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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
          headers: {"authorization": "Bearer $accessToken"});

      if (res.statusCode != 200) {
        throw res.body;
      }

      var resBody = json.decode(res.body);

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
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/user/requested/list"),
          headers: {"authorization": "Bearer $_accessToken"});
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
          isPrivate: user["isPrivate"],
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
}
