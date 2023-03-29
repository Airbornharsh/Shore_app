import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Requests/RequestModalList.dart';
import 'package:shore_app/Components/Requests/RequestedModalList.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/User.dart';

class Requests extends StatefulWidget {
  bool isLoading;
  Function setIsLoading;
  Requests({required this.isLoading, required this.setIsLoading, super.key});
  bool start = true;

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  List<UnsignUserModel> unsignuserRequestingList = [];
  List<UnsignUserModel> unsignuserRequestedList = [];

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      // Provider.of<User>(context, listen: false)
      //     .loadRequestingFollowers()
      //     .then((el) {
      //   setState(() {
      //     unsignuserRequestingList = el;
      //     widget.start = false;
      //   });
      // });
      // Provider.of<User>(context, listen: false)
      //     .loadRequestingFollowing()
      //     .then((el) {
      //   setState(() {
      //     unsignuserRequestedList = el;
      //     widget.start = false;
      //   });
      // });
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          Provider.of<User>(context, listen: false)
              .loadRequestingFollowers()
              .then((el) {
            unsignuserRequestingList = el;
            widget.start = false;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        child: Column(
          children: [
            ExpansionTile(
              iconColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade200
                  : Colors.black,
              backgroundColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade600
                  : Colors.white,
              leading: Icon(Icons.people_rounded,
                  color: Provider.of<AppSetting>(context).getdarkMode
                      ? Colors.grey.shade200
                      : Colors.black),
              title: Text("Follow Requesting",
                  style: TextStyle(
                    color: Provider.of<AppSetting>(context).getdarkMode
                        ? Colors.grey.shade200
                        : Colors.black,
                  )),
              children: [
                RequestModalList(
                    unsignuserRequestingList: unsignuserRequestingList,
                    isLoading: widget.isLoading,
                    setIsLoading: widget.setIsLoading),
              ],
            ),
            ExpansionTile(
              iconColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade200
                  : Colors.black,
              backgroundColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade600
                  : Colors.white,
              leading: Icon(
                Icons.people_rounded,
                color: Provider.of<AppSetting>(context).getdarkMode
                    ? Colors.grey.shade200
                    : Colors.black,
              ),
              title: Text("Follow Requested",
                  style: TextStyle(
                    color: Provider.of<AppSetting>(context).getdarkMode
                        ? Colors.grey.shade200
                        : Colors.black, 
                  )),
              children: [
                RequestedModalList(
                    unsignuserRequestedList: unsignuserRequestedList,
                    isLoading: widget.isLoading,
                    setIsLoading: widget.setIsLoading)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
