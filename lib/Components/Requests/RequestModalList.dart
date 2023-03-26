import 'package:flutter/material.dart';
import 'package:shore_app/Components/Requests/RequestProfileItem.dart';
import 'package:shore_app/models.dart';

class RequestModalList extends StatefulWidget {
  List<UnsignUserModel> unsignuserRequestingList;
  bool isLoading;
  Function setIsLoading;
  RequestModalList(
      {required this.unsignuserRequestingList,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<RequestModalList> createState() => _RequestModalListState();
}

class _RequestModalListState extends State<RequestModalList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.unsignuserRequestingList.length,
        itemBuilder: (context, i) {
          return RequestProfileItem(
              user: widget.unsignuserRequestingList[i],
              isLoading: widget.isLoading,
              setIsLoading: widget.setIsLoading);
        });
  }
}
