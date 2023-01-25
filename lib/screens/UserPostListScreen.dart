import 'package:flutter/material.dart';
import 'package:shore_app/Components/Profile/ProfilePostList/UserPostListItem.dart';
import 'package:shore_app/models.dart';

class UserPostListScreen extends StatefulWidget {
  static String routeName = "user-post-list";
  UserPostListScreen({super.key});

  @override
  State<UserPostListScreen> createState() => UserPostListScreenState();
}

class UserPostListScreenState extends State<UserPostListScreen> {
  @override
  Widget build(BuildContext context) {
    List<UserPostModel> userPostList =
        ModalRoute.of(context)?.settings.arguments as List<UserPostModel>;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Posts")),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: userPostList.length,
                      itemBuilder: ((ctx, i) {
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(userPostList[i].postedDate))
                            .toLocal();

                        String newDate =
                            "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";

                        return UserPostListItem(
                            newDate: newDate, post: userPostList[i]);
                      }))),
            ],
          ),
        )
      ],
    );
  }
}
