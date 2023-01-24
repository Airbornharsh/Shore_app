import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Components/CustomAppBar.dart';
import 'package:shore_app/Components/HomeScreen/Home.dart';
import 'package:shore_app/Components/HomeScreen/Upload.dart';
import 'package:shore_app/Components/Profile/Profile.dart';
import 'package:shore_app/Components/HomeScreen/Requests.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = "/";
  int start = 1;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<PostModel> postList = [];

  @override
  void initState() {
    // TODO: implement initState
    void onLoad() async {
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("hopl_backend_uri", "http://localhost:3000");
      // prefs.setString("shore_backend_uri", "http://10.0.2.2:3000");
      prefs.setString("shore_backend_uri", "https://shore.vercel.app");
    }

    onLoad();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.start == 1) {
        Provider.of<Posts>(context, listen: false).loadPosts().then((el) {
          setState(() {
            postList = el;
            widget.start = 0;
          });
        });
      }
    });

    void reloadPosts() {
      Provider.of<Posts>(context, listen: false).loadPosts().then((el) {
        setState(() {
          postList = el;
        });
      });
    }

    List<Widget> selectedWidget = [
      Home(postList: postList, reloadPosts: reloadPosts),
      const Requests(),
      Profile()
    ];

    return Scaffold(
      appBar: _selectedIndex == 0 || _selectedIndex == 2
          ? CustomAppBar(context)
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: 0,
        iconSize: 30,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        onTap: (value) {
          if (value == 2 &&
              !Provider.of<User>(context, listen: false).getIsAuth) {
            Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
          } else {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
      ),
      body: selectedWidget[_selectedIndex],
    );
  }
}
