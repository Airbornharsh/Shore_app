import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/Components/UserScreen/UserDetails.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/UnsignUser.dart';
import 'package:shore_app/provider/User.dart';

class UserScreen extends StatefulWidget {
  static String routeName = "unsign-user";
  UserScreen({super.key});
  bool start = true;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;
  late UnsignUserModel user;
  List<UserPostModel> unsignUserPostList = [];

  @override
  Widget build(BuildContext context) {
    final UserModel profileDetails = Provider.of<User>(context).getUserDetails;

    if (widget.start) {
      user = ModalRoute.of(context)?.settings.arguments as UnsignUserModel;
      Provider.of<UnsignUser>(context, listen: false)
          .loadUnsignUserPosts(user.id)
          .then((el) {
        setState(() {
          unsignUserPostList = el;
        });
      });
      widget.start = false;
    }

    void reloadUserPosts() {}

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("@${user.userName}"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              Provider.of<UnsignUser>(context, listen: false)
                  .reloadUser(user.id)
                  .then((el) {
                setState(() {
                  user = el;
                });
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
              // height: MediaQuery.of(context).size.height - 220,
              child: Column(
                children: [
                  if (user.id != profileDetails.id) UserDetails(user: user),
                  if (user.id == profileDetails.id)
                    ProfileDetails(user: profileDetails),
                  UserPostList(
                      userPostList: unsignUserPostList,
                      reloadUserPosts: reloadUserPosts),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: const Color.fromRGBO(80, 80, 80, 0.3),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
