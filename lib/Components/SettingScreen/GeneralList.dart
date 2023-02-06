import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/AppSetting.dart';

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
      title: Text("General",
          style: TextStyle(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade200
                : Colors.black,
          )),
      children: [
        ListTile(
          title: Text("Dark Mode",
              style: TextStyle(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade300
                      : Colors.black)),
          trailing: Switch(
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              Provider.of<AppSetting>(context, listen: false)
                  .setDarkMode(value);
            },
            value: Provider.of<AppSetting>(context).getdarkMode,
          ),
        )
      ],
    );
  }
}
