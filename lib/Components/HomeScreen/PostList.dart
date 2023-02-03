import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/HomeScreen/PostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class PostList extends StatefulWidget {
  List<PostModel> postList = [];
  Function addLoad;
  PostList({required this.postList, required this.addLoad, super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          await widget.addLoad();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<User>(context, listen: false).getUserDetails;

    return Expanded(
        child: ListView.builder(
            itemCount: widget.postList.length,
            controller: _controller,
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
