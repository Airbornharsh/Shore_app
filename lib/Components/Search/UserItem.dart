import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/screens/UserScreen.dart';

class UserItem extends StatelessWidget {
  UnsignUserModel user;
  UserItem({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Provider.of<AppSetting>(context).getdarkMode
              ? Colors.grey.shade900
              : Colors.white),
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: Hero(
          tag: "user-${user.id}",
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                  user.imgUrl.isNotEmpty
                      ? user.imgUrl
                      : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low, errorBuilder:
                      (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                return const SizedBox(
                    height: 50, width: 50, child: Center(child: Text('😊')));
              })),
        ),
        title: Text(
          user.name,
          style: TextStyle(
              color: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade200
                  : Colors.black),
        ),
        subtitle: Text(
          "@${user.userName}",
          style: TextStyle(
              color: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade200
                  : Colors.black),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(UserScreen.routeName, arguments: user);
        },
      ),
    );
  }
}
