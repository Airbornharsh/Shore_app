import 'package:flutter/material.dart';

class MessageClicked extends StatelessWidget {
  static String routeName = "/message-clicked";
  const MessageClicked({super.key});

  @override
  Widget build(BuildContext context) {
    final message = (ModalRoute.of(context)!.settings.arguments ??
        {"title": "Error", "body": "No Message"}) as Map<String, dynamic>;

    return Scaffold(
        appBar: AppBar(title: Text("Message")),
        body: Container(
          child: Text("Message: ${message['body']}"),
        ));
  }
}
