import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
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
          color: Provider.of<AppSetting>(context).getdarkMode
              ? Color.fromARGB(255, 32, 32, 32)
              : Colors.white,
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
                        child: Image.network(
                            widget.user.imgUrl.isNotEmpty
                                ? widget.user.imgUrl
                                : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low, errorBuilder:
                                (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                          return Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(),
                              child: const Center(child: Text('😊')));
                        })),
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
                              color:
                                  Provider.of<AppSetting>(context).getdarkMode
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade800),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.newDate,
                          style: TextStyle(
                              fontSize: 12,
                              color:
                                  Provider.of<AppSetting>(context).getdarkMode
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade800),
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
                        style: TextStyle(
                            color: Provider.of<AppSetting>(context).getdarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade800),
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
                          child: Image.network(widget.post.url,
                              filterQuality: FilterQuality.low,
                              cacheHeight:
                                  MediaQuery.of(context).size.width.toInt(),
                              loadingBuilder: (ctx, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                                height: MediaQuery.of(ctx).size.width,
                                width: MediaQuery.of(ctx).size.width,
                                child: const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ));
                          }, errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(),
                                child: Center(
                                    child: Image.asset(
                                        "lib/assets/images/error.png")));
                          }
                              // cacheHeight: MediaQuery.of(context).size.width.toInt(),
                              // cacheWidth: MediaQuery.of(context).size.width.toInt(),
                              ),
                        )
                      : null,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(
                  onTap: () async {
                    if (Provider.of<SignUser>(context, listen: false)
                        .getIsAuth) {
                      try {
                        if (isLiked) {
                          setState(() {
                            // isLiked = false;
                            // _likes -= 1;
                            widget.post.likes.remove(userDetails.id);
                          });
                          await Provider.of<SignUser>(context, listen: false)
                              .postUnlike(widget.post.id);
                        } else {
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
                      Navigator.of(context)
                          .popAndPushNamed(AuthScreen.routeName);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Provider.of<AppSetting>(context).getdarkMode
                              ? Colors.grey.shade800
                              : Colors.grey),
                    ),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLiked
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.grey,
                              ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(_likes.toString(),
                            style: TextStyle(
                                color:
                                    Provider.of<AppSetting>(context).getdarkMode
                                        ? Colors.grey.shade300
                                        : Colors.black))
                      ],
                    )),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Provider.of<AppSetting>(context).getdarkMode
                              ? Colors.grey.shade800
                              : Colors.grey)),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.comment_bank_outlined,
                          color: Colors.grey,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (Provider.of<SignUser>(context, listen: false)
                        .getIsAuth) {
                      try {
                        if (isFav) {
                          setState(() {
                            isFav = false;
                          });
                          await Provider.of<SignUser>(context, listen: false)
                              .postRemoveFav(widget.post.id);
                        } else {
                          setState(() {
                            isFav = true;
                          });
                          await Provider.of<SignUser>(context, listen: false)
                              .postAddFav(widget.post.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      Navigator.of(context)
                          .popAndPushNamed(AuthScreen.routeName);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Provider.of<AppSetting>(context).getdarkMode
                              ? Colors.grey.shade800
                              : Colors.grey),
                    ),
                    child: Center(
                        child: isFav
                            ? const Icon(
                                Icons.bookmark,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.bookmark_add_outlined,
                                color: Colors.grey,
                              )),
                  ),
                ),
              ])
            ],
          )),
        ),
        Container(
          height: 10,
          color: Provider.of<AppSetting>(context).getdarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        )
      ],
    );
  }
}
