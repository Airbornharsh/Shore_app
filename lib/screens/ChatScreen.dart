import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat";
  ChatScreen({super.key});
  bool start = true;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = true;
  // late Socket socketClient;
  List<Message> messages = [];
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    final unsignUser = Provider.of<SignUser>(context).getFriend(userId);
    final signUserId = Provider.of<SignUser>(context).getUserDetails.id;
    if (widget.start) {
      // socketClient = SocketClient.staticInstance.socket!;

      // socketClient.on("receive-message-id", (data) {
      //   print(data["message"]);
      //   setState(() {
      //     messages.add(data["message"]);
      //   });
      // });

      setState(() {
        messages = Provider.of<SignUser>(context).getFriendMessage(userId)
            as List<Message>;
        widget.start = false;
        _isLoading = false;
      });
    }

    Timer(Duration(milliseconds: 1), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // _scrollController.animateTo(
      //   0.0,
      //   curve: Curves.easeOut,
      //   duration: const Duration(milliseconds: 300),
      // );
    });

    // print(messages.length);

    // if (socketClient.connected) {
    //   print("connected with ${socketClient.id}");
    // }
    // if (socketClient.disconnected) {
    //   print("disconnected");
    // }

    void sendMessage() async {
      String messageText = messageController.text;
      messageController.clear();
      bool res = await Provider.of<SignUser>(context, listen: false)
          .sendMessage(userId, messageText);
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              title: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                      unsignUser.imgUrl.isNotEmpty
                          ? unsignUser.imgUrl
                          : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low, errorBuilder:
                          (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                    return Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(),
                        child: const Center(child: Text('😊')));
                  })),
              SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(unsignUser.name, overflow: TextOverflow.ellipsis),
                  Text(
                    "@${unsignUser.userName}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          )),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    if (messageData.from == signUserId) {
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            borderRadius: BorderRadius.circular(4)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.2,
                            bottom: 8,
                            top: 8,
                            right: 12),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          messageData.message,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.2,
                            bottom: 8,
                            top: 8,
                            left: 12),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          messageData.message,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    padding: EdgeInsets.only(right: 48, top: 8, bottom: 8),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      style: TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        sendMessage();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 6,
                    child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(255, 0, 190, 184)),
                        width: 100,
                        height: 100,
                        child: Transform.rotate(
                          angle: -0.6,
                          child: Center(
                            child: Icon(
                              Icons.send,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
