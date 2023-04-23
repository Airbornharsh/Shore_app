import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/EditProfileScreen.dart';
import 'package:shore_app/screens/FollowersScreen.dart';
import 'package:shore_app/screens/FollowingsScreen.dart';
import 'package:shore_app/screens/SettingScreen.dart';

class ProfileDetails extends StatefulWidget {
  final UserModel user;
  const ProfileDetails({required this.user, super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 260,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Hero(
                  tag: "user-${widget.user.id}",
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.user.imgUrl.isNotEmpty
                            ? widget.user.imgUrl
                            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                        height: 90,
                        width: 90,
                        memCacheWidth: 90,
                        memCacheHeight: 90,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        errorWidget: (context, url, error) => Container(
                            height: 90,
                            width: 90,
                            child: Center(
                                child: Image.asset(
                                    "lib/assets/images/error.png"))),
                      )),
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
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "@${widget.user.userName}",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditProfileScreen.routeName);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  const Color.fromARGB(255, 0, 190, 184))),
                          child: const Text(
                            "  Edit Profile  ",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ))
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: 6,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingScreen.routeName);
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 28,
                    color: Colors.grey.shade600,
                  )),
            )
          ],
        ),
      ),
      const SizedBox(
        height: 2,
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white),
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.white,
              width: (MediaQuery.of(context).size.width - 4) / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.posts.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                  Text(
                    "Posts",
                    style: TextStyle(fontSize: 12, color: Colors.black),
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
                Navigator.of(context).pushNamed(FollowersScreen.routeName,
                    arguments: widget.user.id);
              },
              child: Container(
                color: Colors.white,
                width: (MediaQuery.of(context).size.width - 4) / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.followers.length.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                    Text(
                      "Followers",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
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
              child: Container(
                color: Colors.white,
                width: (MediaQuery.of(context).size.width - 4) / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.followings.length.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                    Text(
                      "Following",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
