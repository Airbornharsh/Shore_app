import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class AccountList extends StatefulWidget {
  bool isLoading;
  Function setIsLoading;
  AccountList({super.key, required this.isLoading, required this.setIsLoading});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor:  Colors.black,
      backgroundColor:  Colors.white,
      leading: Icon(Icons.people_sharp,
          color:  Colors.black),
      title: Text("Account",
          style: TextStyle(
            color:  Colors.black,
          )),
      children: [
        ListTile(
          onTap: () async {
            widget.setIsLoading(true);
            await Provider.of<SignUser>(context, listen: false).logout();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            widget.setIsLoading(false);
          },
          title: Text("Log Out",
              style: TextStyle(
                  color:  Colors.black)),
          trailing: Icon(Icons.logout,
              color:  Colors.black),
        ),
      ],
    );
  }
}
