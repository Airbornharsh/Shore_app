import 'package:flutter/material.dart';
import 'package:shore_app/Components/HomeScreen/PostList.dart';
import 'package:shore_app/models.dart';

class Home extends StatefulWidget {
  List<PostModel> postList;
  Function reloadPosts;
  Function addLoad;
  bool isLoadingMore;
  Home(
      {required this.postList,
      required this.reloadPosts,
      required this.addLoad,
      required this.isLoadingMore,
      super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.reloadPosts();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
        // height: MediaQuery.of(context).size.height - 130,
        child: Column(
          children: [
            // if (Provider.of<User>(context).getIsAuth) const Upload(),
            // const Upload(),
            // const SizedBox(
            //   height: 8,
            // ),
            PostList(
              addLoad: widget.addLoad,
              postList: widget.postList,
            ),

            if (widget.isLoadingMore)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
