import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shore_app/Components/Profile/ProfilePostList/UnsignUserPostListItem.dart';
import 'package:shore_app/Components/Profile/ProfilePostList/UserPostListItem.dart';
import 'package:shore_app/Utils/UserPostListScreenArgs.dart';
import 'package:shore_app/provider/SignUser.dart';

import '../models.dart';

class UnsignUserPostListScreen extends StatefulWidget {
  static String routeName = "unsign-user-post-list";
  UnsignUserPostListScreen({super.key});

  @override
  State<UnsignUserPostListScreen> createState() => UnsignUserPostListScreenState();
}

class UnsignUserPostListScreenState extends State<UnsignUserPostListScreen> {
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
    UnsignUserPostListScreenArgs args =
        ModalRoute.of(context)?.settings.arguments as UnsignUserPostListScreenArgs;

    UserModel user = Provider.of<SignUser>(context).getUserDetails;

    Timer(Duration(seconds: 0), () {
      itemScrollController.scrollTo(
          index: args.index, duration: Duration(milliseconds: 300));
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Posts"),
            backgroundColor:  const Color.fromARGB(255, 0, 190, 184),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              args.reloadUserPosts();
            },
            child: Container(
              color: Colors.white,
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

                            if (user.id == args.userPostList[i].userId) {
                              return UserPostListItem(
                                  newDate: newDate, post: args.userPostList[i]);
                            } else {
                              return UnsignUserPostListItem(
                                newDate: newDate,
                                post: args.userPostList[i],
                                user: args.user,
                              );
                            }
                          }))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
