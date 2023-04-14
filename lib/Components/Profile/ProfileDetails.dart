import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
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
      // Image.network(
      //     "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
      //     height: 130,
      //     width: MediaQuery.of(context).size.width,
      //     fit: BoxFit.cover),
      Container(
        height: 260,
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
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
                                child: Image.asset(
                                    "lib/assets/images/error.png")));
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
                                color:
                                    Provider.of<AppSetting>(context).getdarkMode
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
                                color:
                                    Provider.of<AppSetting>(context).getdarkMode
                                        ? Colors.grey.shade300
                                        : Colors.black),
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
                                  Provider.of<AppSetting>(context).getdarkMode
                                      ? const Color.fromARGB(255, 0, 99, 95)
                                      : Provider.of<AppSetting>(context)
                                              .getdarkMode
                                          ? const Color.fromARGB(255, 0, 99, 95)
                                          : const Color.fromARGB(
                                              255, 0, 190, 184))),
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
                    color: Provider.of<AppSetting>(context).getdarkMode
                        ? Colors.grey.shade200
                        : Colors.grey.shade600,
                  )),
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
            ),
          ],
        ),
      ),
    ]);
  }
}
