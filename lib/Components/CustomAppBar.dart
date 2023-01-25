import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/NewPostScreen.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const NewPostScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutSine;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

AppBar CustomAppBar(BuildContext context) {
  return AppBar(
    actions: [
      if (!Provider.of<User>(context, listen: false).getIsAuth)
        IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
            },
            icon: const Icon(Icons.login)),
      IconButton(
          onPressed: () {
            if (Provider.of<User>(context, listen: false).getIsAuth) {
              // showModalBottomSheet(
              //     context: context,
              //     builder: (BuildContext ctx) {
              //       return Container(
              //         color: Colors.white,
              //         child: const SingleChildScrollView(child: Upload()),
              //       );
              //     });
              // Navigator.of(context).pushNamed(NewPostScreen.routeName);
              Navigator.of(context).push(_createRoute());
            } else {
              Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
            }
          },
          icon: const Icon(Icons.post_add))
    ],
    toolbarHeight: 130,
    title: Center(
      child: Container(
          width: MediaQuery.of(context).size.width * 80 / 100,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 1, 214, 207),
              borderRadius: BorderRadius.circular(60)),
          child: const TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                icon: Icon(Icons.search, color: Colors.white),
                iconColor: Colors.white,
                suffixIconColor: Colors.white),
          )),
    ),
  );
}
