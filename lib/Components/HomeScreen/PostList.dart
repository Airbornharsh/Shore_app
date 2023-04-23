import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/Components/HomeScreen/PostItem.dart';
import 'package:shore_app/models.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return Container();
      },
    ));
  }
}
