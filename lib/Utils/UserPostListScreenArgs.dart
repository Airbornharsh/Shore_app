import 'package:shore_app/models.dart';

class UserPostListScreenArgs {
  final List<UserPostModel> userPostList;
  final Function reloadUserPosts;
  final int index;

  UserPostListScreenArgs(
      {required this.userPostList,
      required this.reloadUserPosts,
      required this.index});
}

class UnsignUserPostListScreenArgs {
  final List<UserPostModel> userPostList;
  final Function reloadUserPosts;
  final int index;
  final UnsignUserModel user;

  UnsignUserPostListScreenArgs(
      {required this.userPostList,
      required this.reloadUserPosts,
      required this.user,
      required this.index});
}
