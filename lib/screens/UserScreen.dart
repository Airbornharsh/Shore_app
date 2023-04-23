import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UnsignUserPostList.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/Components/UserScreen/UserDetails.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/UnsignUser.dart';
import 'package:shore_app/provider/SignUser.dart';

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
  bool isPrivate = true;

  @override
  Widget build(BuildContext context) {
    final UserModel profileDetails =
        Provider.of<SignUser>(context).getUserDetails;

    if (widget.start) {
      _isLoading = true;
      user = ModalRoute.of(context)?.settings.arguments as UnsignUserModel;
      print(user.id);
      Provider.of<UnsignUser>(context, listen: false)
          .loadUnsignUserPosts(user.id)
          .then((el) {
        setState(() {
          unsignUserPostList = el;
          _isLoading = false;
        });
      });

      isPrivate = !Provider.of<SignUser>(context)
          .getUserDetails
          .followings
          .contains(user.id);
      setState(() {
        widget.start = false;
      });
    }

    void reloadUserPosts() {}

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("@${user.userName}"),
            backgroundColor: const Color.fromARGB(255, 0, 190, 184),
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
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Column(
                children: [
                  if (user.id != profileDetails.id) UserDetails(user: user),
                  if (user.id == profileDetails.id)
                    ProfileDetails(user: profileDetails),
                  if (user.id != profileDetails.id)
                    UnsignUserPostList(
                        userPostList: unsignUserPostList,
                        reloadUserPosts: reloadUserPosts,
                        user: user),
                  if (user.id == profileDetails.id)
                    UserPostList(
                      userPostList: unsignUserPostList,
                      reloadUserPosts: reloadUserPosts,
                    )
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
