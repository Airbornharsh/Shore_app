import 'package:flutter/material.dart';
import 'package:shore_app/Components/Requests/RequestedProfileItem.dart';
import 'package:shore_app/models.dart';

class RequestedModalList extends StatefulWidget {
  List<UnsignUserModel> unsignuserRequestedList;
  bool isLoading;
  Function setIsLoading;
  RequestedModalList(
      {required this.unsignuserRequestedList,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<RequestedModalList> createState() => _RequestedModalListState();
}

class _RequestedModalListState extends State<RequestedModalList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: widget.unsignuserRequestedList.length,
        itemBuilder: (context, i) {
          return RequestedProfileItem(
              user: widget.unsignuserRequestedList[i],
              isLoading: widget.isLoading,
              setIsLoading: widget.setIsLoading);
        });
  }
}
