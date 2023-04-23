import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/UserListBuilder.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class FollowingsScreen extends StatefulWidget {
  static String routeName = "followings";
  FollowingsScreen({super.key});
  bool start = true;

  @override
  State<FollowingsScreen> createState() => _FollowingsScreenState();
}

class _FollowingsScreenState extends State<FollowingsScreen> {
  bool _isLoading = false;
  List<UnsignUserModel> followingsUsers = [];
  late String userId;

  @override
  Widget build(BuildContext context) {
    setState(() {
      userId = ModalRoute.of(context)?.settings.arguments as String;
    });

    if (widget.start) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<SignUser>(context, listen: false)
          .loadFollowingsUsers(userId: userId)
          .then((el) {
        setState(() {
          _isLoading = false;
          followingsUsers = el;
          widget.start = false;
        });
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Following"),
            backgroundColor: const Color.fromARGB(255, 0, 190, 184),
          ),
          body: UserListBuilder(users: followingsUsers, addMoreUser: () {}),
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
