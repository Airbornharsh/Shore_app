import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/NewPostScreen.dart';
import 'package:shore_app/screens/SearchScreen.dart';

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
    backgroundColor: const Color.fromARGB(255, 0, 190, 184),
    actions: [
      if (Provider.of<SignUser>(context).getIsAuth)
        IconButton(
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
            icon: const Icon(Icons.post_add,size: 26,)),
    ],
    toolbarHeight: 96,
    title: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(SearchScreen.routeName);
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 80 / 100,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 243, 243),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 3))
                ]),
            child: const IgnorePointer(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    icon: Icon(Icons.search, color: Colors.black),
                    iconColor: Colors.white,
                    suffixIconColor: Colors.white),
              ),
            )),
      ),
    ),
  );
}
