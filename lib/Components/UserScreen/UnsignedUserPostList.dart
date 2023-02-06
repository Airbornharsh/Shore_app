import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/Components/Profile/UserPostItem.dart';
import 'package:shore_app/Utils/userPostListScreenArgs.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/UserPostListScreen.dart';

class UserPostList extends StatefulWidget {
  List<UserPostModel> userPostList;
  Function reloadUserPosts;
  UserPostList(
      {required this.userPostList, required this.reloadUserPosts, super.key});

  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> {
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
                  Navigator.of(ctx).pushNamed(UserPostListScreen.routeName,
                      arguments: UserPostListScreenArgs(
                          userPostList: widget.userPostList,
                          reloadUserPosts: widget.reloadUserPosts,
                          index: i));
                },
                child: UserPostItem(userPostItem: widget.userPostList[i]));
          })),
    );
  }
}