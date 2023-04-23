import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Post/PostActivity.dart';
import 'package:shore_app/Components/Post/PostDetailRender.dart';
import 'package:shore_app/Components/Post/PostImage.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';

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
  int likes = 0;

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
        likes = widget.post.likes.length;
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
                    if (Provider.of<SignUser>(context, listen: false)
                        .getIsAuth) {
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
                      Navigator.of(context)
                          .popAndPushNamed(AuthScreen.routeName);
                    }
                  },
                  child: PostImage(
                      postUrl: widget.post.url, postId: widget.post.id)),
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
