import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class PostItem extends StatefulWidget {
  String newDate;
  PostModel post;
  PostItem({required this.newDate, required this.post, super.key});
  int start = 1;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    UserModel userDetails =
        Provider.of<User>(context, listen: false).getUserDetails;

    if (widget.start == 1) {
      setState(() {
        isLiked = Provider.of<Posts>(context, listen: false)
            .isUserLiked(widget.post, userDetails.id);
        isFav = Provider.of<Posts>(context, listen: false)
            .isUserFav(userDetails, widget.post.id);

        print(isFav);
      });
      widget.start = 0;
    }

    return Column(
      children: [
        Container(
          height: 360,
          color: Colors.white,
          child: SizedBox(
              height: 300,
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
                              "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(
                          width: 7,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Harsh Keshri",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.newDate,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      if (Provider.of<User>(context, listen: false).getIsAuth) {
                        try {
                          if (isLiked) {
                            setState(() {
                              isLiked = false;
                            });
                            await Provider.of<User>(context, listen: false)
                                .postUnlike(widget.post.id);
                          } else {
                            setState(() {
                              isLiked = true;
                            });
                            await Provider.of<User>(context, listen: false)
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
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(31, 165, 165, 165)),
                      child: Image.network(
                        widget.post.url,
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (Provider.of<User>(context, listen: false)
                                .getIsAuth) {
                              try {
                                if (isLiked) {
                                  setState(() {
                                    isLiked = false;
                                  });
                                  await Provider.of<User>(context,
                                          listen: false)
                                      .postUnlike(widget.post.id);
                                } else {
                                  setState(() {
                                    isLiked = true;
                                  });
                                  await Provider.of<User>(context,
                                          listen: false)
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
                              border: Border.all(color: Colors.grey),
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
                                Text(widget.post.likes.length.toString())
                              ],
                            )),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  
                                },
                                icon: const Icon(
                                  Icons.comment_bank_outlined,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (Provider.of<User>(context, listen: false)
                                .getIsAuth) {
                              try {
                                if (isFav) {
                                  setState(() {
                                    isFav = false;
                                  });
                                  await Provider.of<User>(context,
                                          listen: false)
                                      .postRemoveFav(widget.post.id);
                                } else {
                                  setState(() {
                                    isFav = true;
                                  });
                                  await Provider.of<User>(context,
                                          listen: false)
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
                              border: Border.all(color: Colors.grey),
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
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
