import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/Components/Profile/UserPostItem.dart';
import 'package:shore_app/Utils/UserPostListScreenArgs.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/UnsignUserPostListScreen.dart';

class UnsignUserPostList extends StatefulWidget {
  List<UserPostModel> userPostList;
  Function reloadUserPosts;
  UnsignUserModel user;
  UnsignUserPostList(
      {required this.userPostList,
      required this.reloadUserPosts,
      required this.user,
      super.key});
  bool start = true;

  @override
  State<UnsignUserPostList> createState() => _UnsignUserPostListState();
}

class _UnsignUserPostListState extends State<UnsignUserPostList> {
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: widget.userPostList.length,
          itemBuilder: ((ctx, i) {
            return GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pushNamed(UnsignUserPostListScreen.routeName,
                      arguments: UnsignUserPostListScreenArgs(
                          user: widget.user,
                          userPostList: widget.userPostList,
                          reloadUserPosts: widget.reloadUserPosts,
                          index: i));
                },
                child: UserPostItem(userPostItem: widget.userPostList[i]));
          })),
    );
  }
}
