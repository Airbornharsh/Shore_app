import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/SignUser.dart';

class ActivitiesList extends StatefulWidget {
  const ActivitiesList({super.key});

  @override
  State<ActivitiesList> createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Provider.of<AppSetting>(context).getdarkMode
          ? Colors.grey.shade200
          : Colors.black,
      backgroundColor: Provider.of<AppSetting>(context).getdarkMode
          ? Colors.grey.shade600
          : Colors.white,
      leading: Icon(Icons.people_sharp,
          color: Provider.of<AppSetting>(context).getdarkMode
              ? Colors.grey.shade200
              : Colors.black),
      title: Text("Activities",
          style: TextStyle(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade200
                : Colors.black,
          )),
      children: [
        ListTile(
          onTap: () {},
          title: Text("Liked Posts",
              style: TextStyle(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade300
                      : Colors.black)),
          trailing: Icon(Icons.favorite_border,
              color: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade300
                  : Colors.black),
        ),
        ListTile(
          onTap: () {},
          title: Text("Bookmarked Posts",
              style: TextStyle(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade300
                      : Colors.black)),
          trailing: Icon(Icons.bookmark_border,
              color: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade300
                  : Colors.black),
        ),
      ],
    );
  }
}
