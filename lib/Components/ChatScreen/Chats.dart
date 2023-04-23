import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/ChatScreen.dart';

class Chats extends StatefulWidget {
  Function setIsLoading;
  bool isLoading;
  Chats({super.key, required this.setIsLoading, required this.isLoading});
  bool start = true;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UnsignUserModel> friends = Provider.of<SignUser>(context).getFriends;

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<SignUser>(context, listen: false).loadFriendsUsers();
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(ChatScreen.routeName,
                          arguments: friends[index].id);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: friends[index].imgUrl.isNotEmpty
                              ? friends[index].imgUrl
                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          height: 50,
                          width: 50,
                          memCacheWidth: 50,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          errorWidget: (context, url, error) => Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(),
                              child: const Center(child: Text('😊'))),
                        )),
                    title: Text(friends[index].name),
                    subtitle: Text("Tap to Message"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
