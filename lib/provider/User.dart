import 'package:flutter/cupertino.dart';
import 'package:shore_app/models.dart';

class User with ChangeNotifier {
  late final  UserModel _user = UserModel(
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
  final bool _isAuth = false;

  bool get getIsAuth {
    return _isAuth;
  }

  UserModel get getUserDetails {
    return _user;
  }
  
}
