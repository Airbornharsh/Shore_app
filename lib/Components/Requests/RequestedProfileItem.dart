import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/UserScreen.dart';

class RequestedProfileItem extends StatefulWidget {
  final UnsignUserModel user;
  bool isLoading;
  Function setIsLoading;
  RequestedProfileItem(
      {required this.user,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<RequestedProfileItem> createState() => _RequestedProfileItemState();
}

class _RequestedProfileItemState extends State<RequestedProfileItem> {
  String response = "";
  bool isResponsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        style: ListTileStyle.list,
        leading: Hero(
          tag: "user-${widget.user.id}",
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.user.imgUrl.isNotEmpty
                    ? widget.user.imgUrl
                    : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                height: 50,
                width: 50,
                memCacheHeight: 50,
                memCacheWidth: 50,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                errorWidget: (context, url, error) => const SizedBox(
                    height: 50, width: 50, child: Center(child: Text('😊'))),
              )),
        ),
        title: Text(
          widget.user.name,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          "@${widget.user.userName}",
          style: TextStyle(color: Colors.black),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(UserScreen.routeName, arguments: widget.user);
        },
      ),
    );
  }
}
