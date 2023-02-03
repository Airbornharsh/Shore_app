import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/UserListBuilder.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class FollowersScreen extends StatefulWidget {
  static String routeName = "followers";
  FollowersScreen({super.key});
  bool start = true;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool _isLoading = false;
  List<UnsignUserModel> followersUsers = [];
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
      Provider.of<User>(context, listen: false)
          .loadFollowersUsers(userId: userId)
          .then((el) {
        setState(() {
          _isLoading = false;
          followersUsers = el;
        });
      });

      widget.start = false;
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Followers"),
          ),
          body: UserListBuilder(users: followersUsers, addMoreUser: () {}),
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
