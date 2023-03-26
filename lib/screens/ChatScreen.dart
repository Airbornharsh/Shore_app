import 'package:flutter/material.dart';
import "dart:io";

import 'package:provider/provider.dart';
import 'package:shore_app/provider/AppSetting.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // late IO.Socket socket;`
  late Socket socket;

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  @override
  void dispose() {
    //...
    // socket.disconnect();
    // socket.dispose();
    super.dispose();
    //...
  }

  initSocket() {
    // socket = IO.io(
    //     "https://shore.vercel.app/user/socket",
    //     IO.OptionBuilder()
    //         .setTransports(['websocket']) // for Flutter or Dart VM
    //         .disableAutoConnect() // disable auto-connection
    //         .setExtraHeaders({}) // optional
    //         .build());

    // socket.connect();
    // socket.onConnect((_) {
    //   print('Connection established');
    // });
    // socket.onDisconnect((_) => print('Connection Disconnection'));
    // socket.onConnectError((err) => print(err));
    // socket.onError((err) => print(err));

    Socket.connect("localhost", 3000).then((Socket sock) {
      socket = sock;
      socket.listen((context) {},
          onError: () {}, onDone: () {}, cancelOnError: false);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              onPressed: () {},
              style:  ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Provider.of<AppSetting>(context).getdarkMode
                        ? const Color.fromARGB(255, 0, 99, 95)
                        : const Color.fromARGB(255, 0, 190, 184)),
              ),
              child: const Text(
                "Click Me",
                style: TextStyle(color: Colors.white),
              ))),
    );
  }
}
