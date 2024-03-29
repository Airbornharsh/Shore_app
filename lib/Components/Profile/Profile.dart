import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class Profile extends StatefulWidget {
  final List<UserPostModel> userPostList;
  final Function reloadUserPosts;
  Profile(
      {required this.userPostList, required this.reloadUserPosts, super.key});
  bool start = true;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserModel user;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<SignUser>(context).getUserDetails;
    });

    if (widget.start) {}

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<SignUser>(context, listen: false).reloadUser().then((el) {
          setState(() {
            user = el;
          });
        });

        widget.reloadUserPosts();
      },
      child: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(31, 121, 121, 121)),
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
