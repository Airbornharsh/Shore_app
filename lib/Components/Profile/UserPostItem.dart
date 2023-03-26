import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/UserScreen/UserDetails.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/PostEditScreen.dart';

class UserPostItem extends StatefulWidget {
  UserPostModel userPostItem;
  UserPostItem({required this.userPostItem, super.key});

  @override
  State<UserPostItem> createState() => _UserPostItemState();
}

class _UserPostItemState extends State<UserPostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      // margin: EdgeInsets.all(1),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
      child: Hero(
        tag: widget.userPostItem.id,
        child: Image.network(widget.userPostItem.url,
            filterQuality: FilterQuality.low,
            fit: BoxFit.cover, errorBuilder: (BuildContext context,
                Object exception, StackTrace? stackTrace) {
          return SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:
                  Center(child: Image.asset("lib/assets/images/error.png")));
        }),
      ),
    );
  }
}
