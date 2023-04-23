import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/HomeScreen/PostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class PostList extends StatefulWidget {
  List<PostModel> postList = [];
  Function addLoad;
  Function setIsLoading;
  bool isLoading;
  ScrollController scrollController;
  Function setTop;
  PostList(
      {required this.postList,
      required this.addLoad,
      required this.isLoading,
      required this.setIsLoading,
      required this.scrollController,
      required this.setTop,
      super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  // ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // widget.scrollController = _controller;

    widget.scrollController.addListener(() async {
      if (widget.scrollController.position.atEdge) {
        bool isTop = widget.scrollController.position.pixels == 0;
        if (!isTop) {
          widget.setTop(false);
          await widget.addLoad();
        } else {
          widget.setTop(true);
        }
      } else {
        setState(() {
          widget.setTop(false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<SignUser>(context, listen: false).getUserDetails;

    return Expanded(
        child: ListView.separated(
      itemCount: widget.postList.length,
      controller: widget.scrollController,
      itemBuilder: ((ctx, i) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.postList[i].postedDate))
            .toLocal();

        return PostItem(
            newDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(widget.postList[i].postedDate)),
            post: widget.postList[i],
            isLoading: widget.isLoading,
            setIsLoading: widget.setIsLoading);
      }),
      // physics: ScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(),
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
