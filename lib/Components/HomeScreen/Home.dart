import 'package:flutter/material.dart';
import 'package:shore_app/Components/HomeScreen/PostList.dart';
import 'package:shore_app/models.dart';

class Home extends StatefulWidget {
  List<PostModel> postList;
  Function reloadPosts;
  Function addLoad;
  Function setIsLoading;
  bool isLoading;
  bool isLoadingMore;
  Home(
      {required this.postList,
      required this.reloadPosts,
      required this.addLoad,
      required this.isLoadingMore,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isTop = true;
  ScrollController _scrollController = ScrollController();

  void setTop(bool isTop) {
    setState(() {
      _isTop = isTop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
      child: RefreshIndicator(
        onRefresh: () async {
          widget.reloadPosts();
        },
        child: Stack(
          children: [
            Column(
              children: [
                PostList(
                    addLoad: widget.addLoad,
                    postList: widget.postList,
                    isLoading: widget.isLoading,
                    setIsLoading: widget.setIsLoading,
                    scrollController: _scrollController,
                    setTop: setTop),
              ],
            ),
            if (!_isTop)
              Positioned(
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          curve: Curves.bounceInOut,
                          duration: Duration(milliseconds: 500));
                    },
                    child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.keyboard_double_arrow_up_outlined,
                          size: 23,
                          color: Colors.white,
                        )),
                  ),
                  bottom: 16,
                  right: 16),
            Positioned(
                child: widget.isLoadingMore
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ))
                    : const SizedBox(),
                bottom: 9,
                left: MediaQuery.of(context).size.width / 2 - 12),
          ],
        ),
      ),
    );
  }
}
