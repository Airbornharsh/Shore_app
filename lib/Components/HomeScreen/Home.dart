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
            // if (Provider.of<SignUser>(context).getIsAuth) const Upload(),
            // const Upload(),
            // const SizedBox(
            // height: 8,
            // ),
            // PhoneNumber(),
            Column(
              children: [
                PostList(
                  addLoad: widget.addLoad,
                  postList: widget.postList,
                  isLoading: widget.isLoading,
                  setIsLoading: widget.setIsLoading,
                ),
              ],
            ),
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
