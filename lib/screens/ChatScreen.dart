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
  final messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketId = ModalRoute.of(context)!.settings.arguments as String;
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
        "message": "${messageController.text}",
        "senderUserId": ""
      });
    }

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]),
                    );
                  },
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(
                          color: Provider.of<AppSetting>(context).getdarkMode
                              ? Colors.grey.shade400
                              : Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(
                          color: Provider.of<AppSetting>(context).getdarkMode
                              ? Colors.grey.shade400
                              : Colors.black,
                        ),
                        fillColor: Provider.of<AppSetting>(context).getdarkMode
                            ? Colors.grey.shade900
                            : Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 11,
                    child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: const Color.fromARGB(255, 0, 190, 184),
                      ),
                    ),
                  ),
                ],
              ),
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
