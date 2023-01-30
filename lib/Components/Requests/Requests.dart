import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Requests/RequestModalList.dart';
import 'package:shore_app/models.dart';
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
  List<UnsignUserModel> unsignuserList = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.start) {
        Provider.of<User>(context, listen: false)
            .loadRequestingFollowers()
            .then((el) {
          unsignuserList = el;
          widget.start = false;
        });
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          Provider.of<User>(context, listen: false)
              .loadRequestingFollowers()
              .then((el) {
            unsignuserList = el;
            widget.start = false;
          });
        });
      },
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) {
                      return RequestModalList(
                          unsignuserList: unsignuserList,
                          isLoading: widget.isLoading,
                          setIsLoading: widget.setIsLoading);
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const ListTile(
                    leading: Icon(Icons.people_rounded),
                    title: Text("Follow Requests"),
                    trailing: Icon(Icons.expand_more),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
