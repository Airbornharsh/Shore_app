import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/FollowersScreen.dart';
import 'package:shore_app/screens/FollowingsScreen.dart';

class UserDetails extends StatefulWidget {
  UnsignUserModel user;
  UserDetails({required this.user, super.key});
  bool start = true;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String isFollowing = "Follow";

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      final res = Provider.of<User>(context).isFollowing(widget.user.id);
      setState(() {
        if (res.isEmpty) {
          isFollowing = "";
        } else {
          isFollowing = res;
        }
        widget.start = false;
      });
    }

    return Column(children: [
      Container(
        height: 260,
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Hero(
              tag: "user-${widget.user.id}",
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      widget.user.imgUrl.isNotEmpty
                          ? widget.user.imgUrl
                          : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low, errorBuilder:
                          (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                    return Container(
                        width: 90,
                        height: 90,
                        child: Center(
                            child: Image.asset("lib/assets/images/error.png")));
                  })),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Provider.of<AppSetting>(context).getdarkMode
                                ? Colors.grey.shade300
                                : Colors.black),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "@${widget.user.userName}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Provider.of<AppSetting>(context).getdarkMode
                                ? Colors.grey.shade300
                                : Colors.black),
                      )
                    ],
                  ),
                  if (isFollowing == "Follow")
                    TextButton(
                        onPressed: () async {
                          if (Provider.of<User>(context, listen: false)
                              .getIsAuth) {
                            try {
                              final res = await Provider.of<User>(context,
                                      listen: false)
                                  .follow(widget.user.id);
                              widget.user.followers.add(
                                  Provider.of<User>(context, listen: false)
                                      .getUserDetails
                                      .id);
                              setState(() {
                                isFollowing = res;
                              });
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            Navigator.of(context)
                                .popAndPushNamed(AuthScreen.routeName);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                          Provider.of<AppSetting>(context).getdarkMode
                              ? const Color.fromARGB(255, 0, 99, 95)
                              : const Color.fromARGB(255, 0, 190, 184),
                        )),
                        child: Text(
                          isFollowing,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )),
                  if (isFollowing == "Requested")
                    TextButton(
                        onPressed: () async {
                          if (Provider.of<User>(context, listen: false)
                              .getIsAuth) {
                            try {
                              await Provider.of<User>(context, listen: false)
                                  .unfollow(widget.user.id);
                              widget.user.followers.remove(
                                  Provider.of<User>(context, listen: false)
                                      .getUserDetails
                                      .id);
                              setState(() {
                                isFollowing = "Follow";
                              });
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            Navigator.of(context)
                                .popAndPushNamed(AuthScreen.routeName);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.grey.shade400),
                        ),
                        child: Text(
                          isFollowing,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )),
                  if (isFollowing == "Following")
                    TextButton(
                        onPressed: () async {
                          if (Provider.of<User>(context, listen: false)
                              .getIsAuth) {
                            try {
                              await Provider.of<User>(context, listen: false)
                                  .unfollow(widget.user.id);
                              widget.user.followers.remove(
                                  Provider.of<User>(context, listen: false)
                                      .getUserDetails
                                      .id);
                              setState(() {
                                isFollowing = "Follow";
                              });
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            Navigator.of(context)
                                .popAndPushNamed(AuthScreen.routeName);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.grey.shade400),
                        ),
                        child: Text(
                          isFollowing,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )),
                ],
              ),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Container(
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.posts.length.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      color: Provider.of<AppSetting>(context).getdarkMode
                          ? Colors.grey.shade200
                          : Colors.black),
                ),
                Text(
                  "Posts",
                  style: TextStyle(
                      fontSize: 12,
                      color: Provider.of<AppSetting>(context).getdarkMode
                          ? Colors.grey.shade200
                          : Colors.black),
                )
              ],
            ),
            Container(
              width: 2,
              height: 20,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(FollowersScreen.routeName,
                    arguments: widget.user.id);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.followers.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Provider.of<AppSetting>(context).getdarkMode
                            ? Colors.grey.shade200
                            : Colors.black),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(
                        fontSize: 12,
                        color: Provider.of<AppSetting>(context).getdarkMode
                            ? Colors.grey.shade200
                            : Colors.black),
                  )
                ],
              ),
            ),
            Container(
              width: 2,
              height: 20,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(FollowingsScreen.routeName,
                    arguments: widget.user.id);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.followings.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Provider.of<AppSetting>(context).getdarkMode
                            ? Colors.grey.shade200
                            : Colors.black),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(
                        fontSize: 12,
                        color: Provider.of<AppSetting>(context).getdarkMode
                            ? Colors.grey.shade200
                            : Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
