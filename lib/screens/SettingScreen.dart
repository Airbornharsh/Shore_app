import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/SettingScreen/AccountList.dart';
import 'package:shore_app/Components/SettingScreen/ActivitiesList.dart';
import 'package:shore_app/Components/SettingScreen/GeneralList.dart';
import 'package:shore_app/provider/AppSetting.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = "/setting";
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: Provider.of<AppSetting>(context).getdarkMode
            ? const Color.fromARGB(255, 0, 99, 95)
            : const Color.fromARGB(255, 0, 190, 184),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        child: Column(
          children: const [GeneralList(), AccountList(), ActivitiesList()],
        ),
      ),
    );
  }
}
