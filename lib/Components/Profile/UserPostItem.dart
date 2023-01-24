import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/screens/PostEditScreen.dart';

class UserPostItem extends StatelessWidget {
  UserPostModel userPostItem;
  UserPostItem({required this.userPostItem, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context)
            .pushNamed(PostEditScreen.routeName, arguments: userPostItem);
      },
      child: Card(
        child: Stack(
          children: [
            Center(
              child: Image.network(
                userPostItem.url,
                filterQuality: FilterQuality.low,
              ),
            ),
            // Positioned(
            //   child: Container(child: Text(userPostItem.likes.length.toString())),
            // )
          ],
        ),
      ),
    );
  }
}
