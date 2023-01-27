import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Components/CustomAppBar.dart';
import 'package:shore_app/Components/HomeScreen/Home.dart';
import 'package:shore_app/Components/Profile/Profile.dart';
import 'package:shore_app/Components/HomeScreen/Requests.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = "/";
  bool start = true;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<PostModel> postList = [];
  List<UserPostModel> userPostList = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController();

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
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.start) {
        Provider.of<User>(context, listen: false).onLoad().then((el) {
          if (el) {
            Provider.of<User>(context, listen: false)
                .loadUserPosts()
                .then((el) {
              setState(() {
                userPostList = el;
                widget.start = false;
              });
            });
          }
        });

        Provider.of<Posts>(context, listen: false).loadPosts().then((el) {
          setState(() {
            postList = el;
            widget.start = false;
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

    void reloadUserPosts() {
      if (Provider.of<User>(context, listen: false).getIsAuth) {
        Provider.of<User>(context, listen: false).loadUserPosts().then((el) {
          setState(() {
            userPostList = el;
          });
        });
      }
    }

    List<Widget> selectedWidget = [
      Home(postList: postList, reloadPosts: reloadPosts),
      const Requests(),
      Profile(userPostList: userPostList, reloadUserPosts: reloadUserPosts)
    ];

    return Scaffold(
      appBar: CustomAppBar(context),
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
          // onTap: (value) {
          //   if (value == 2 &&
          //       !Provider.of<User>(context, listen: false).getIsAuth) {
          //     Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
          //   } else {
          //     setState(() {
          //       _selectedIndex = value;
          //     });
          //   }
          // },
          onTap: _onItemTapped),
      body: SizedBox.expand(
          child: PageView(
        controller: _pageController,
        onPageChanged: ((i) => setState(() => _selectedIndex = i)),
        children: selectedWidget,
      )),
    );
  }
}
