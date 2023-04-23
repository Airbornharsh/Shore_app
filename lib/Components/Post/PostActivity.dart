import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/CommentScreen.dart';

class PostActivity extends StatefulWidget {
  bool isLiked;
  bool isFav;
  String userId;
  List<String> likes;
  String postId;
  String likesNo;
  String commentNo;
  PostActivity({
    super.key,
    required this.isLiked,
    required this.isFav,
    required this.userId,
    required this.likes,
    required this.postId,
    required this.likesNo,
    required this.commentNo,
  });

  @override
  State<PostActivity> createState() => _PostActivityState();
}

class _PostActivityState extends State<PostActivity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                if (Provider.of<SignUser>(context, listen: false).getIsAuth) {
                  try {
                    if (widget.isLiked) {
                      setState(() {
                        widget.likes.remove(widget.userId);
                      });
                      await Provider.of<SignUser>(context, listen: false)
                          .postUnlike(widget.postId);
                    } else {
                      setState(() {
                        widget.likes.add(widget.userId);
                      });
                      await Provider.of<SignUser>(context, listen: false)
                          .postLike(widget.postId);
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
                }
              },
              child: Center(
                  child: Container(
                height: 44,
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset:
                            const Offset(1, 1), 
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                              opacity: child.key == ValueKey('icon1')
                                  ? Tween<double>(begin: 1, end: 0.5)
                                      .animate(anim)
                                  : Tween<double>(begin: 0.75, end: 1)
                                      .animate(anim),
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                        child: widget.isLiked
                            ? Icon(Icons.favorite,
                                size: 25,
                                color: Color.fromARGB(255, 0, 190, 184),
                                key: const ValueKey('icon1'))
                            : Icon(
                                Icons.favorite_border_outlined,
                                size: 25,
                                color: Colors.grey.shade800,
                                key: const ValueKey('icon2'),
                              )),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.likesNo,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  CommentScreen.routeName,
                  arguments: widget.postId,
                );
              },
              child: Center(
                child: Container(
                  height: 44,
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset:
                              const Offset(1, 1), 
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.comment_bank_outlined,
                          size: 25, color: Colors.grey.shade800),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.commentNo.toString(),
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (Provider.of<SignUser>(context, listen: false).getIsAuth) {
                  try {
                    if (widget.isFav) {
                      setState(() {
                        widget.isFav = false;
                      });
                      await Provider.of<SignUser>(context, listen: false)
                          .postRemoveFav(widget.postId);
                    } else {
                      setState(() {
                        widget.isFav = true;
                      });
                      await Provider.of<SignUser>(context, listen: false)
                          .postAddFav(widget.postId);
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
                }
              },
              child: Center(
                child: Container(
                  height: 44,
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset:
                              const Offset(1, 1), 
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                              opacity: child.key == ValueKey('icon3')
                                  ? Tween<double>(begin: 1, end: 0.5)
                                      .animate(anim)
                                  : Tween<double>(begin: 0.75, end: 1)
                                      .animate(anim),
                              child: ScaleTransition(scale: anim, child: child),
                            ),
                        child: widget.isFav
                            ? Icon(Icons.bookmark,
                                size: 25,
                                color: Colors.grey.shade800,
                                key: const ValueKey('icon3'))
                            : Icon(
                                Icons.bookmark_add_outlined,
                                size: 25,
                                color: Colors.grey.shade800,
                                key: const ValueKey('icon4'),
                              )),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
