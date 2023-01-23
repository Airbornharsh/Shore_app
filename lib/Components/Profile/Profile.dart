import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Profile/ProfileDetails.dart';
import 'package:shore_app/Components/Profile/UserPostList.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  int start = 1;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<UserPostModel> userPostList = [];
  late UserModel user;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<User>(context, listen: false).getUserDetails;
    });

    if (widget.start == 1) {
      Provider.of<User>(context, listen: false).loadUserPosts().then((el) {
        setState(() {
          print(widget.start);
          userPostList = el;
          widget.start = 0;
        });
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<User>(context, listen: false).reloadUser().then((El) {
          setState(() {
            user = El;
          });
        });
      },
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ProfileDetails(user: user),
              UserPostList(userPostList: userPostList)
            ],
          ),
        ),
      ),
    );
  }
}
