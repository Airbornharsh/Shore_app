import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/HomeScreen/PostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';

class PostList extends StatefulWidget {
  List<PostModel> postList = [];
  PostList({required this.postList, super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<User>(context, listen: false).getUserDetails;

    return Expanded(
        child: ListView.builder(
            itemCount: widget.postList.length,
            itemBuilder: ((ctx, i) {
              DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.postList[i].postedDate))
                  .toLocal();

              String newDate =
                  "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";

              return PostItem(newDate: newDate, post: widget.postList[i]);
            })));
  }
}
