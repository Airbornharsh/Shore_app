import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class Profile extends StatefulWidget {
  final List<UserPostModel> userPostList;
  final Function reloadUserPosts;
  Profile(
      {required this.userPostList, required this.reloadUserPosts, super.key});
  int start = 1;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // List<UserPostModel> userPostList = [];
  late UserModel user;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<User>(context).getUserDetails;
    });

    if (widget.start == 1) {}

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<User>(context, listen: false).reloadUser().then((el) {
          setState(() {
            user = el;
          });
        });

        widget.reloadUserPosts();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
        height: MediaQuery.of(context).size.height - 220,
        child: Column(
          children: [
            ProfileDetails(user: user),
            UserPostList(
                userPostList: widget.userPostList,
                reloadUserPosts: widget.reloadUserPosts),
          ],
        ),
      ),
    );
  }
}
