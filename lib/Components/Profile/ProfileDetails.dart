import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/EditProfileScreen.dart';

class ProfileDetails extends StatefulWidget {
  UserModel user;
  ProfileDetails({required this.user, super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        // Image.network(
        //     "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        //     height: 130,
        //     width: MediaQuery.of(context).size.width,
        //     fit: BoxFit.cover),
        Container(
          height: 260,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.user.imgUrl.isNotEmpty
                        ? widget.user.imgUrl
                        : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                  )),
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
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "@${widget.user.userName}",
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditProfileScreen.routeName);
                          },
                          child: const Text(
                            "  Edit Profile  ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          )),
                    )
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
          decoration: const BoxDecoration(color: Colors.white),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                  const Text(
                    "Posts",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Container(
                width: 2,
                height: 20,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.followers.length.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                  const Text(
                    "Followers",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Container(
                width: 2,
                height: 20,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.followings.length.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                  const Text(
                    "Following",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
