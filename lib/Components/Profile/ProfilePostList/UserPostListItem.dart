import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/PostActivity.dart';
import 'package:shore_app/Components/PostDetailRender.dart';
import 'package:shore_app/Components/UserScreen/UserDetails.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/CommentScreen.dart';

class UserPostListItem extends StatefulWidget {
  String newDate;
  UserPostModel post;
  UserPostListItem({required this.newDate, required this.post, super.key});
  bool start = true;

  @override
  State<UserPostListItem> createState() => _UserPostListItemState();
}

class _UserPostListItemState extends State<UserPostListItem> {
  bool isLiked = false;
  bool isFav = false;
  int _likes = 0;

  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<SignUser>(context, listen: false).getUserDetails;

    if (widget.start) {
      setState(() {
        isLiked = Provider.of<Posts>(context, listen: false)
            .isUserLiked(widget.post.likes, userDetails.id);
        isFav = Provider.of<Posts>(context, listen: false)
            .isUserFav(userDetails, widget.post.id);
        _likes = widget.post.likes.length;
      });
      widget.start = false;
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: SizedBox(
              child: Column(
            children: [
              PostDetailRender(
                  profileUrl: userDetails.imgUrl,
                  profileName: userDetails.name,
                  profileUserName: userDetails.userName,
                  newDate: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.post.postedDate))),
              if (widget.post.description.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.description,
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                onDoubleTap: () async {
                  if (Provider.of<SignUser>(context, listen: false).getIsAuth) {
                    try {
                      if (!isLiked) {
                        setState(() {
                          // isLiked = true;
                          // _likes += 1;
                          widget.post.likes.add(userDetails.id);
                        });
                        await Provider.of<SignUser>(context, listen: false)
                            .postLike(widget.post.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(31, 165, 165, 165)),
                  child: widget.post.url.isNotEmpty
                      ? Hero(
                          tag: widget.post.id,
                          child: CachedNetworkImage(
                            imageUrl: widget.post.url,
                            memCacheWidth: MediaQuery.of(context)
                                .size
                                .width
                                .toInt(), //  cacheWidth: MediaQuery.of(context).size.width.toInt(),
                            filterQuality: FilterQuality.low,
                            placeholder: (context, url) => SizedBox(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )),
                            errorWidget: (context, url, error) => Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(),
                                child: Center(
                                    child: Image.asset(
                                        "lib/assets/images/error.png"))),
                          ),
                        )
                      : null,
                ),
              ),
              PostActivity(
                isLiked: isLiked,
                isFav: isFav,
                userId: userDetails.id,
                likes: widget.post.likes,
                postId: widget.post.id,
                likesNo: widget.post.likes.length.toString(),
                commentNo: widget.post.comments.length.toString(),
              )
            ],
          )),
        ),
        Container(
          height: 15,
          color: Colors.white,
        )
      ],
    );
  }
}
