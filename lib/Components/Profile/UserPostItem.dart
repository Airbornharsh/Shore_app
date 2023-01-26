import 'package:flutter/material.dart';
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
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        // margin: EdgeInsets.all(1),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
        child: Hero(
          tag: userPostItem.id,
          child: Image.network(userPostItem.url,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover, errorBuilder: (BuildContext context,
                  Object exception, StackTrace? stackTrace) {
            return SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child:
                    Center(child: Image.asset("lib/assets/images/error.png")));
          }),
        ),
      ),
    );
  }
}
