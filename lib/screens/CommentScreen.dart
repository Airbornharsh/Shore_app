import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = "/comment";
  CommentScreen({super.key});
  bool start = true;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isLoading = true;
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    commentController.dispose();
  }

  void sendComment(String postId) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<SignUser>(context, listen: false)
        .sendComment(postId, commentController.text);

    setState(() {
      _isLoading = false;
    });

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    comments = Provider.of<SignUser>(context).getComments(postId);
    setState(() {
      if (widget.start) {
        setState(() {
          widget.start = false;
        });

        Provider.of<SignUser>(context).loadComments(postId).then((value) {
          _isLoading = false;
        });
      }
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        padding: EdgeInsets.only(
                            left: 8, right: 9, top: 8, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CachedNetworkImage(
                                      imageUrl: comments[index]
                                              .imgUrl
                                              .isNotEmpty
                                          ? comments[index].imgUrl
                                          : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      height: 40,
                                      width: 40,
                                      memCacheWidth: 40,
                                      memCacheHeight: 40,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              height: 40,
                                              width: 40,
                                              child: Center(
                                                  child: Image.asset(
                                                      "lib/assets/images/error.png"))),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comments[index].name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "@${comments[index].userName}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comments[index].description,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 8,
                          bottom: 8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("dd MMM yyyy").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(comments[index].time))),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade800),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                DateFormat("kk:hh").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(comments[index].time))),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade800),
                              )
                            ],
                          ))
                    ],
                  );
                },
              )),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    padding: EdgeInsets.only(right: 48, top: 8, bottom: 8),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      maxLines: null,
                      controller: commentController,
                      style: TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        sendComment(postId);
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
                        FocusScope.of(context).unfocus();
                        sendComment(postId);
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
