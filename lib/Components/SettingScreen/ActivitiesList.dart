import 'package:flutter/material.dart';
import 'package:shore_app/screens/LikedPosts.dart';

class ActivitiesList extends StatefulWidget {
  const ActivitiesList({super.key});

  @override
  State<ActivitiesList> createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor:  Colors.black,
      backgroundColor:  Colors.white,
      leading: Icon(Icons.people_sharp,
          color:  Colors.black),
      title: Text("Activities",
          style: TextStyle(
            color:  Colors.black,
          )),
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(LikedPostsScreen.routeName);
          },
          title: Text("Liked Posts",
              style: TextStyle(
                  color:  Colors.black)),
          trailing: Icon(Icons.favorite_border,
              color:  Colors.black),
        ),
      ],
    );
  }
}
