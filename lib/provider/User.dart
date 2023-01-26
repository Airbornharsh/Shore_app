import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
      followers: [],
      followings: [],
      closeFriends: [],
      requestingFriends: [],
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

  void logout() {}

  Future<bool> onLoad() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;

    try {
      String accessToken = prefs.get("shore_accessToken") as String;

      if (accessToken.isEmpty) return false;

      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $accessToken"});

      if (userRes.statusCode != 200) {
        throw userRes.body;
      }

      var parsedUserBody = json.decode(userRes.body);

      _isAuth = true;
      _accessToken = accessToken;

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
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          requestingFriends: List<Map<String, dynamic>>.from(
              parsedUserBody["requestingFriends"]),
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

    print(domainUri);
    try {
      var userRes = await client.get(Uri.parse("$domainUri/api/user/get"),
          headers: {"authorization": "Bearer $_accessToken"});

      if (userRes.statusCode != 200) {
        throw userRes.body;
      }

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
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          requestingFriends: List<Map<String, dynamic>>.from(
              parsedUserBody["requestingFriends"]),
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

  Future<String> signIn(String emailId, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("shore_backend_uri") as String;

    print(domainUri);
    try {
      var tokenRes = await client.post(Uri.parse("$domainUri/api/user/login"),
          body: json.encode({"emailId": emailId, "password": password}),
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
          followers: List<String>.from(parsedUserBody["followers"]),
          followings: List<String>.from(parsedUserBody["followings"]),
          closeFriends: List<String>.from(parsedUserBody["closeFriends"]),
          requestingFriends: List<Map<String, dynamic>>.from(
              parsedUserBody["requestingFriends"]),
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
            "password": password
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

      print(fileUrl);

      final accessToken = prefs.get("shore_accessToken") as String;

      var postRes = await client.post(Uri.parse("$domainUri/api/user/post/add"),
          body: json.encode({"url": fileUrl, "description": description}),
          headers: {"authorization": "Bearer $accessToken"});

      if (postRes.statusCode != 200) {
        throw postRes.body;
      }

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

      print(resBody);

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

      print(resBody);

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

      print(resBody);

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

      print(resBody);

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

      print(postResBody);

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

      final tempdestination = _user.imgUrl
          .split("?alt")[0]
          .split("appspot.com/o/")[1]
          .replaceAll("%2F", "/");

      final ref = FirebaseStorage.instance.ref(tempdestination);

      await ref.delete();

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
}
