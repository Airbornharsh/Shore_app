import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

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
    if (widget.start) {}

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          Provider.of<SignUser>(context, listen: false)
              .loadRequestingFollowers()
              .then((el) {
            unsignuserRequestingList = el;
            widget.start = false;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
