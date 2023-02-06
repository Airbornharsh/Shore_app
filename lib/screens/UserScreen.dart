import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/Components/UserScreen/UserDetails.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
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
  bool isPrivate = true;

  @override
  Widget build(BuildContext context) {
    final UserModel profileDetails = Provider.of<User>(context).getUserDetails;

    if (widget.start) {
      setState(() {
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

        isPrivate = !Provider.of<User>(context)
            .getUserDetails
            .followings
            .contains(user.id);
      });
      widget.start = false;
    }

    void reloadUserPosts() {}

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("@${user.userName}"),
            backgroundColor: Provider.of<AppSetting>(context).getdarkMode
                ? const Color.fromARGB(255, 0, 99, 95)
                : const Color.fromARGB(255, 0, 190, 184),
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
                   BoxDecoration(color: Provider.of<AppSetting>(context)
                                              .getdarkMode
                                          ? Colors.grey.shade700
                                          : Colors.white),
              // height: MediaQuery.of(context).size.height - 220,
              child: Column(
                children: [
                  if (user.id != profileDetails.id) UserDetails(user: user),
                  if (user.id == profileDetails.id)
                    ProfileDetails(user: profileDetails),
                  if (!isPrivate)
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
