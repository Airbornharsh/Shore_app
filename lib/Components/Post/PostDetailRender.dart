import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetailRender extends StatelessWidget {
  String profileUrl;
  String profileName;
  String profileUserName;
  DateTime newDate;
  PostDetailRender(
      {super.key,
      required this.profileUrl,
      required this.profileName,
      required this.profileUserName,
      required this.newDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: profileUrl.isNotEmpty
                    ? profileUrl
                    : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                height: 50,
                width: 50,
                memCacheWidth: 50,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                errorWidget: (context, url, error) => const SizedBox(
                    height: 50, width: 50, child: Center(child: Text('😊'))),
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey.shade800),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "@${profileUserName}",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.grey.shade800),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("dd MMM yyyy").format(newDate),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade800),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      DateFormat.jm().format(newDate),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade800),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
