import 'package:flutter/material.dart';

class GeneralList extends StatefulWidget {
  const GeneralList({super.key});

  @override
  State<GeneralList> createState() => _GeneralListState();
}

class _GeneralListState extends State<GeneralList> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Colors.black,
      backgroundColor: Colors.white,
      leading: Icon(Icons.people_sharp, color: Colors.black),
      title: Text("General",
          style: TextStyle(
            color: Colors.black,
          )),
      children: [],
    );
  }
}
