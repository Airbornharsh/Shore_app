import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/models.dart';

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
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
      child: Hero(
        tag: widget.userPostItem.id,
        child: CachedNetworkImage(
          imageUrl: widget.userPostItem.url,
          memCacheWidth: MediaQuery.of(context).size.width ~/ 3,
          filterQuality: FilterQuality.low,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Center(child: Image.asset("lib/assets/images/error.png"))),
        ),
      ),
    );
  }
}
