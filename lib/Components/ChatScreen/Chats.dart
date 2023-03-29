import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/socket_client.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/screens/ChatScreen.dart';

class Chats extends StatefulWidget {
  Function setIsLoading;
  bool isLoading;
  Chats({super.key, required this.setIsLoading, required this.isLoading});
  // bool start = true;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    // final socketClient = SocketClient.instance.socket!;

    // if (socketClient.connected) {
    //   print("connected with ${socketClient.id}");
    // }
    // if (socketClient.disconnected) {
    //   print("disconnected");
    // }

    return RefreshIndicator(
      onRefresh: () async {},
      child: Container(
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(ChatScreen.routeName);
              },
              title: Text("New Chat"),
              subtitle: Text("10 unread Message"),
            )
          ],
        ),
      ),
    );
  }
}
