import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/PostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';

class PostList extends StatefulWidget {
  PostList({super.key});
  int start = 1;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<PostModel> postList = [];

  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<User>(context, listen: false).getUserDetails;

    if (widget.start == 1) {
      Provider.of<Posts>(context).loadPosts().then((el) {
        setState(() {
          postList = el;
          widget.start = 0;
        });
      });
    }

    return Expanded(
        child: ListView.builder(
            itemCount: postList.length,
            itemBuilder: ((ctx, i) {
              DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(postList[i].postedDate))
                  .toLocal();

              String newDate =
                  "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";

              return PostItem(
                newDate: newDate,
                post: postList[i]
              );
            })));
  }
}
