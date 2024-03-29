import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/UserScreen.dart';

class RequestProfileItem extends StatefulWidget {
  final UnsignUserModel user;
  bool isLoading;
  Function setIsLoading;
  RequestProfileItem(
      {required this.user,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<RequestProfileItem> createState() => _RequestProfileItemState();
}

class _RequestProfileItemState extends State<RequestProfileItem> {
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
            children: [
              if (isResponsed)
                Text(
                  response,
                  style: const TextStyle(color: Colors.black),
                ),
              if (!isResponsed)
                IconButton(
                    onPressed: () async {
                      try {
                        widget.setIsLoading(true);

                        final res =
                            await Provider.of<SignUser>(context, listen: false)
                                .declineFollowRequest(widget.user.id);

                        if (!res) {
                          snackBar(context, "Try Again");
                        } else {
                          setState(() {
                            isResponsed = true;
                            response = "Declined";
                          });
                        }
                        widget.setIsLoading(false);
                      } catch (e) {
                        widget.setIsLoading(false);
                        print(e);
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
              if (!isResponsed)
                IconButton(
                    onPressed: () async {
                      try {
                        widget.setIsLoading(true);

                        final res =
                            await Provider.of<SignUser>(context, listen: false)
                                .acceptFollowRequest(widget.user.id);

                        if (!res) {
                          snackBar(context, "Try Again");
                        } else {
                          setState(() {
                            isResponsed = true;
                            response = "Accepted";
                          });
                        }
                        widget.setIsLoading(false);
                      } catch (e) {
                        widget.setIsLoading(false);
                        print(e);
                      }
                    },
                    icon: const Icon(Icons.check, color: Colors.green))
            ],
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
