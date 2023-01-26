import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shore_app/Components/Profile/ProfilePostList/UserPostListItem.dart';
import 'package:shore_app/Utils/userPostListScreenArgs.dart';

class UserPostListScreen extends StatefulWidget {
  static String routeName = "user-post-list";
  UserPostListScreen({super.key});

  @override
  State<UserPostListScreen> createState() => UserPostListScreenState();
}

class UserPostListScreenState extends State<UserPostListScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    UserPostListScreenArgs args =
        ModalRoute.of(context)?.settings.arguments as UserPostListScreenArgs;

    Timer(Duration(seconds: 0), () {
      itemScrollController.scrollTo(
          index: args.index, duration: Duration(milliseconds: 300));
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Posts")),
          body: RefreshIndicator(
            onRefresh: () async {
              args.reloadUserPosts();
            },
            child: Column(
              children: [
                Expanded(
                    child: ScrollablePositionedList.builder(
                        itemCount: args.userPostList.length,
                        itemPositionsListener: itemPositionsListener,
                        itemScrollController: itemScrollController,
                        itemBuilder: ((ctx, i) {
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(args.userPostList[i].postedDate))
                              .toLocal();

                          String newDate =
                              "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";

                          return UserPostListItem(
                              newDate: newDate, post: args.userPostList[i]);
                        }))),
              ],
            ),
          ),
        )
      ],
    );
  }
}
