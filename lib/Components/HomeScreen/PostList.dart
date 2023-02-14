import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
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
        child: ListView.separated(
      itemCount: widget.postList.length,
      controller: _controller,
      itemBuilder: ((ctx, i) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.postList[i].postedDate))
            .toLocal();

        String newDate =
            "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";

        return PostItem(newDate: newDate, post: widget.postList[i]);
      }),
      separatorBuilder: (BuildContext context, int index) {
        // if (index % 2 == 0 && Platform.isAndroid) {
        //   return Container(
        //     child: Card(
        //         color: Colors.white,
        //         child: AdmobBanner(
        //             adUnitId: "ca-app-pub-1856488952723088/3203828354",
        //             adSize: AdmobBannerSize.ADAPTIVE_BANNER(
        //                 width: (MediaQuery.of(context).size.width).round()))),
        //   );
        // }
        return Container();
      },
    ));
  }
}
