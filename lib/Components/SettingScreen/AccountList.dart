import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
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
      title: Text("Account",
          style: TextStyle(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade200
                : Colors.black,
          )),
      children: [
        ListTile(
          onTap: () {
            Provider.of<SignUser>(context, listen: false).logout();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          },
          title: Text("Log Out",
              style: TextStyle(
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade300
                      : Colors.black)),
          trailing: Icon(Icons.logout,
              color: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade300
                  : Colors.black),
        ),
      ],
    );
  }
}
