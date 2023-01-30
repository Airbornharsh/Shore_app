import 'package:flutter/material.dart';
import 'package:shore_app/Components/Requests/RequestProfileItem.dart';
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
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ListView.builder(
              itemCount: widget.unsignuserRequestedList.length,
              itemBuilder: (context, i) {
                return RequestedProfileItem(
                    user: widget.unsignuserRequestedList[i],
                    isLoading: widget.isLoading,
                    setIsLoading: widget.setIsLoading);
              }),
          Positioned(
              bottom: 10,
              left: (MediaQuery.of(context).size.width / 2) - 40,
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Close")))
        ],
      ),
    );
  }
}
