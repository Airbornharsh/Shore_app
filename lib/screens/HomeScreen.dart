import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shore_app/Components/ChatScreen/Chats.dart';
import 'package:shore_app/Components/CustomAppBar.dart';
import 'package:shore_app/Components/HomeScreen/Home.dart';
import 'package:shore_app/Components/Profile/Profile.dart';
import 'package:shore_app/Components/Requests/Requests.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  // static const routeName = "/";
  bool start = true;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _postPage = 1;
  List<PostModel> postList = [];
  List<UserPostModel> userPostList = [];
  PageController _pageController = PageController();
  bool _isLoading = false;
  bool _isPostLoadingMore = false;

  void setIsPostLoadingMore(bool val) {
    setState(() {
      _isPostLoadingMore = val;
    });
  }

  Future<dynamic> notificationSetting() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notificationSetting();

    _pageController = PageController();

    void onLoad() async {
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("hopl_backend_uri", "http://localhost:3000");
      // prefs.setString("shore_backend_uri", "http://10.0.2.2:3000");
      prefs.setString("shore_backend_uri", "https://shore.vercel.app");
      prefs.setString("shore_backend_socket_uri", "http://192.168.118.224:4000");
    }

    onLoad();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if ((index == 2 || index == 1) &&
        !Provider.of<User>(context, listen: false).getIsAuth) {
      Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
    }
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart);
    });
  }

  @override
  Widget build(BuildContext context) {
    // fAuth.FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });

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

      Provider.of<AppSetting>(context, listen: false).onLoad();
    });

    void reloadPosts() {
      Provider.of<Posts>(context, listen: false).loadPosts().then((el) {
        setState(() {
          _postPage = 1;
          postList.clear();
          postList.addAll(el);
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

    void setIsLoading(bool val) {
      setState(() {
        _isLoading = val;
      });
    }

    Future<void> addLoad() async {
      if (!_isPostLoadingMore) {
        try {
          setIsPostLoadingMore(true);
          var el = await Provider.of<Posts>(context, listen: false)
              .loadNewPosts(_postPage + 1);

          setState(() {
            postList.addAll(el);
            _postPage += 1;
          });
          setIsPostLoadingMore(false);
        } catch (e) {
          print(e);
        }
      }
    }

    List<Widget> selectedWidget = [
      Home(
          postList: postList,
          reloadPosts: reloadPosts,
          addLoad: addLoad,
          isLoadingMore: _isPostLoadingMore),
      Requests(isLoading: _isLoading, setIsLoading: setIsLoading),
      Chats(isLoading: _isLoading, setIsLoading: setIsLoading),
      Profile(userPostList: userPostList, reloadUserPosts: reloadUserPosts)
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(context),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedFontSize: 0,
              iconSize: 30,
              selectedItemColor: Colors.grey.shade600,
              backgroundColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.black
                  : Colors.white,
              unselectedItemColor: Provider.of<AppSetting>(context).getdarkMode
                  ? Colors.grey.shade400
                  : Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
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
          body: Container(
            color: Provider.of<AppSetting>(context).getdarkMode
                ? Colors.grey.shade800
                : Colors.white,
            child: SizedBox.expand(
                child: PageView(
              controller: _pageController,
              onPageChanged: ((i) => setState(() => _selectedIndex = i)),
              children: selectedWidget,
            )),
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
