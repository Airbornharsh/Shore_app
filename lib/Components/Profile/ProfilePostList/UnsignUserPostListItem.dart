import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Post/PostActivity.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class UnsignUserPostListItem extends StatefulWidget {
  String newDate;
  UserPostModel post;
  UnsignUserModel user;
  UnsignUserPostListItem(
      {required this.newDate,
      required this.user,
      required this.post,
      super.key});
  bool start = true;

  @override
  State<UnsignUserPostListItem> createState() => _UnsignUserPostListItemState();
}

class _UnsignUserPostListItemState extends State<UnsignUserPostListItem> {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.imgUrl.isNotEmpty
                              ? widget.user.imgUrl
                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          height: 50,
                          width: 50,
                          memCacheWidth: 50,
                          memCacheHeight: 50,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          errorWidget: (context, url, error) => Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(),
                              child: const Center(child: Text('😊'))),
                        )),
                    const SizedBox(
                      width: 7,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey.shade800),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.newDate,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade800),
                        )
                      ],
                    )
                  ],
                ),
              ),
              if (widget.post.description.isNotEmpty)
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.description,
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
                      ? CachedNetworkImage(
                          imageUrl: widget.post.url,
                          filterQuality: FilterQuality.low,
                          memCacheWidth:
                              MediaQuery.of(context).size.width.toInt(),
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
          height: 10,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
