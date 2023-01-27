import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Search/UserItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/UnsignUser.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<UnsignUserModel> _users = [];

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future searchFun() async {
      try {
        setState(() {
          _isLoading = true;
        });

        final users = await Provider.of<UnsignUser>(context, listen: false)
            .loadUsers(_searchController.text);
        setState(() {
          _users = users;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("ok");
        print(e);
      }
    }

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Hero(
                  tag: "search-bar",
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        // icon: Icon(Icons.search, color: Colors.white),
                        suffixIcon: Icon(Icons.search, color: Colors.white),
                        iconColor: Colors.white,
                        suffixIconColor: Colors.white),
                    autofocus: true,
                    autocorrect: true,
                    onSubmitted: (value) async {
                      await searchFun();
                    },
                    // onSubmitted: _searchController.text.isNotEmpty
                    //     ? (value) async {
                    //         await searchFun();
                    //       }
                    //     : null,
                  )),
            ),
            body: Container(
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (ctx, i) {
                  return UserItem(
                    user: _users[i],
                  );
                },
              ),
            )),
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
