import 'package:flutter/material.dart';
import 'package:shore_app/Components/Requests/RequestProfileItem.dart';
import 'package:shore_app/models.dart';

class RequestModalList extends StatefulWidget {
  List<UnsignUserModel> unsignuserList;
  bool isLoading;
  Function setIsLoading;
  RequestModalList(
      {required this.unsignuserList,
      required this.isLoading,
      required this.setIsLoading,
      super.key});

  @override
  State<RequestModalList> createState() => _RequestModalListState();
}

class _RequestModalListState extends State<RequestModalList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ListView.builder(
              itemCount: widget.unsignuserList.length,
              itemBuilder: (context, i) {
                return RequestProfileItem(
                    user: widget.unsignuserList[i],
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
