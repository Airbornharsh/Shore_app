import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/UserListBuilder.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/UnsignUser.dart';
import 'package:shore_app/provider/SignUser.dart';

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
  int _page = 1;
  bool _isLoadingMore = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  void setIsLoadingMore(bool val) {
    setState(() {
      _isLoadingMore = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future searchFun() async {
      try {
        setState(() {
          _isLoading = true;
        });

        final users = await Provider.of<UnsignUser>(context, listen: false)
            .loadUsers(_searchController.text, _page);
        setState(() {
          _users = users;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
      }
    }

    Future<void> addMoreUser() async {
      if (!_isLoadingMore) {
        try {
          setIsLoadingMore(true);
          var el = await Provider.of<UnsignUser>(context, listen: false)
              .loadMoreUsers(_searchController.text, _page + 1);

          setState(() {
            _users.addAll(el);
            _page += 1;
          });
          setIsLoadingMore(false);
        } catch (e) {
          print(e);
        }
      }
    }

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Provider.of<AppSetting>(context).getdarkMode
                  ? const Color.fromARGB(255, 0, 99, 95)
                  : const Color.fromARGB(255, 0, 190, 184),
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
                      if (Provider.of<SignUser>(context, listen: false).getIsAuth) {
                        await searchFun();
                      } else {
                        snackBar(context, "Please Log In");
                      }
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
              child: Column(children: [
                Expanded(
                    child: UserListBuilder(
                        users: _users, addMoreUser: addMoreUser)),
                if (_isLoadingMore)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const CircularProgressIndicator(),
                  )
              ]),
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
