import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/socket_client.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat";
  ChatScreen({super.key});
  bool start = true;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;
  late Socket socketClient;
  List<String> messages = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // final socketId = ModalRoute.of(context)!.settings.arguments as String;
    final socketId = "-Hh0tgRkenFOekseAAAD";
    if (widget.start) {
      socketClient = SocketClient.instance.socket!;

      socketClient.on("receive-message-id", (data) {
        print(data["message"]);
        setState(() {
          messages.add(data["message"]);
        });
      });
      setState(() {
        widget.start = false;
      });
    }

    print(messages.length);

    if (socketClient.connected) {
      print("connected with ${socketClient.id}");
    }
    if (socketClient.disconnected) {
      print("disconnected");
    }

    void sendMessage() {
      count++;
      socketClient.emit("send-message-id", {
        "receiverSocketId": socketId,
        "message": "Hii Bro $count",
        "senderUserId": ""
      });
    }

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Container(
                height: 800,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                    );
                  },
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 0, 190, 184),
                  )),
                  onPressed: () {
                    sendMessage();
                  },
                  child: Text("Send", style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: const Color.fromRGBO(80, 80, 80, 0.3),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
