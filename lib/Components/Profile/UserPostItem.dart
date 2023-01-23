import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/models.dart';

class UserPostItem extends StatelessWidget {
  UserPostModel userPostItem;
  UserPostItem({required this.userPostItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Center(
            child: Image.network(userPostItem.url),
          ),
          // Positioned(
          //   child: Container(child: Text(userPostItem.likes.length.toString())),
          // )
        ],
      ),
    );
  }
}
