import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/HomeScreen/PostItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';

class LikedPostsScreen extends StatefulWidget {
  static const String routeName = "/liked-posts";
  LikedPostsScreen({super.key});
  bool start = true;

  @override
  State<LikedPostsScreen> createState() => _LikedPostsScreenState();
}

class _LikedPostsScreenState extends State<LikedPostsScreen> {
  bool _isLoading = true;
  List<PostModel> likedPosts = [];

  void setIsLoading(bool data) {
    setState(() {
      _isLoading = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    likedPosts = Provider.of<SignUser>(context).getUserLikedPosts;
    if (widget.start) {
      setState(() {
        widget.start = false;
      });

      Provider.of<SignUser>(context, listen: false)
          .getLikedPosts()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Liked Posts'),
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: likedPosts.length,
                itemBuilder: (context, i) {
                  return PostItem(
                      newDate: DateTime.fromMillisecondsSinceEpoch(
                          int.parse(likedPosts[i].postedDate)),
                      post: likedPosts[i],
                      isLoading: _isLoading,
                      setIsLoading: setIsLoading);
                },
              )),
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
