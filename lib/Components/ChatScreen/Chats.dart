import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/socket_client.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/screens/ChatScreen.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Chats extends StatefulWidget {
  Function setIsLoading;
  bool isLoading;
  Chats({super.key, required this.setIsLoading, required this.isLoading});
  bool start = true;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late Socket socketClient;
  List<String> ids = [];

  @override
  void initState() {
    super.initState();
    // print("hII");
    socketClient = SocketClient.staticInstance.socket!;
    print("Mine Socket id is ${socketClient.id}");

    socketClient.emit("list-ids-request");

    socketClient.on("list-ids-response", (data) {
      print(data["ids"]);

      setState(() {
        ids.clear();
        data["ids"].forEach((element) {
          ids.add(element);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(socketClient.id);
    // final socketClient = SocketClient.instance.socket!;

    // if (socketClient.connected) {
    //   print("connected with ${socketClient.id}");
    // }
    // if (socketClient.disconnected) {
    //   print("disconnected");
    // }

    if (widget.start) {
      // socketClient = SocketClient.instance.socket!;
      // print("Mine Socket id is ${socketClient.id}");

      // socketClient.emit("list-ids-request");

      // socketClient.on("list-ids-response", (data) {
      //   print(data["ids"]);

      //   setState(() {
      //     ids.clear();
      //     data["ids"].forEach((element) {
      //       ids.add(element);
      //     });
      //   });
      // });

      // setState(() {
      //   widget.start = false;
      // });
    }

    return RefreshIndicator(
      onRefresh: () async {
        socketClient.emit("list-ids-request");
      },
      child: Container(
        decoration: BoxDecoration(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade900
                : Colors.white),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: ids.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ChatScreen.routeName, arguments: ids[index]);
                  },
                  title: Text(ids[index]),
                  subtitle: Text("10 unread Message"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
