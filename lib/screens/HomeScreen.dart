import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/ChatScreen/Chats.dart';
import 'package:shore_app/Components/CustomAppBar.dart';
import 'package:shore_app/Components/HomeScreen/Home.dart';
import 'package:shore_app/Components/Profile/Profile.dart';
import 'package:shore_app/Utils/cloud_firestore.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/Components/NewPostContainer.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = "";
  bool start = true;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _postPage = 1;
  List<PostModel> postList = [];
  List<UserPostModel> userPostList = [];
  late final PageController _pageController;
  bool _isLoading = true;
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
    notificationSetting();
    cloud_firestore.updateAvailability();

    _pageController = PageController(initialPage: 1);

    void onLoad() async {
      //Prefs.prefs.setString("hopl_backend_uri", "http://localhost:3000");
      //Prefs.prefs.setString("shore_backend_uri", "http://10.0.2.2:3000");
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
      _pageController.animateToPage(index + 1,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutQuart);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.start) {
      Provider.of<SignUser>(context, listen: false).init();
      Provider.of<SignUser>(context, listen: false).loadUserPosts().then((el) {
        setState(() {
          userPostList = el;
          // setState(() {
          widget.start = false;
          // });
        });
      });

      Provider.of<Posts>(context, listen: false).loadPosts().then((el) {
        setState(() {
          postList = el;
          // setState(() {
          widget.start = false;
          _isLoading = false;
          // });
        });
      });

      Provider.of<SignUser>(
        context,
        listen: false,
      ).loadFriendsUsers();
    }

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
      if (Provider.of<SignUser>(context, listen: false).getIsAuth) {
        Provider.of<SignUser>(context, listen: false)
            .loadUserPosts()
            .then((el) {
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
      NewPostContainer(isLoading: _isLoading, setIsLoading: setIsLoading),
      Home(
          postList: postList,
          reloadPosts: reloadPosts,
          addLoad: addLoad,
          isLoadingMore: _isPostLoadingMore,
          isLoading: _isLoading,
          setIsLoading: setIsLoading),
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
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                            opacity: child.key == ValueKey('icon6')
                                ? Tween<double>(begin: 1, end: 0.5)
                                    .animate(anim)
                                : Tween<double>(begin: 0.75, end: 1)
                                    .animate(anim),
                            child: ScaleTransition(scale: anim, child: child),
                          ),
                      child: _selectedIndex == 0
                          ? Icon(Icons.home,
                              color: Color.fromARGB(255, 0, 190, 184),
                              key: const ValueKey('icon5'))
                          : Icon(
                              Icons.home,
                              color: Colors.grey.shade800,
                              key: const ValueKey('icon6'),
                            )),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                            opacity: child.key == ValueKey('icon6')
                                ? Tween<double>(begin: 1, end: 0.5)
                                    .animate(anim)
                                : Tween<double>(begin: 0.75, end: 1)
                                    .animate(anim),
                            child: ScaleTransition(scale: anim, child: child),
                          ),
                      child: _selectedIndex == 1
                          ? Icon(Icons.chat,
                              color: Color.fromARGB(255, 0, 190, 184),
                              key: const ValueKey('icon5'))
                          : Icon(
                              Icons.chat,
                              color: Colors.grey.shade800,
                              key: const ValueKey('icon6'),
                            )),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                            opacity: child.key == ValueKey('icon6')
                                ? Tween<double>(begin: 1, end: 0.5)
                                    .animate(anim)
                                : Tween<double>(begin: 0.75, end: 1)
                                    .animate(anim),
                            child: ScaleTransition(scale: anim, child: child),
                          ),
                      child: _selectedIndex == 2
                          ? Icon(Icons.person,
                              color: Color.fromARGB(255, 0, 190, 184),
                              key: const ValueKey('icon5'))
                          : Icon(
                              Icons.person,
                              color: Colors.grey.shade800,
                              key: const ValueKey('icon6'),
                            )),
                  label: "",
                ),
              ],
              onTap: _onItemTapped),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(content: Text("Tap back again to Exit")),
            child: Container(
              color: Colors.white,
              child: SizedBox.expand(
                  child: PageView(
                controller: _pageController,
                onPageChanged: ((i) => setState(() {
                      if (i < 1) {
                        _selectedIndex = 0;
                      } else {
                        _selectedIndex = i - 1;
                      }
                    })),
                children: selectedWidget,
              )),
            ),
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
