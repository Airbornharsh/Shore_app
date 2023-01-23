import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/Components/Profile/UserPostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class UserPostList extends StatefulWidget {
  List<UserPostModel> userPostList;
  UserPostList({required this.userPostList, super.key});

  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: widget.userPostList.length,
          itemBuilder: ((ctx, i) {
            return UserPostItem(userPostItem: widget.userPostList[i]);
          })),
    );
  }
}
