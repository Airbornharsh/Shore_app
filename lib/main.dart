import 'dart:async';
import 'dart:convert';

import "package:firebase_app_check/firebase_app_check.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/Prefs.dart';
import 'package:shore_app/Utils/firebase_options.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/UnsignUser.dart';
import 'package:shore_app/provider/SignUser.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/ChatScreen.dart';
import 'package:shore_app/screens/CommentScreen.dart';
import 'package:shore_app/screens/EditProfileScreen.dart';
import 'package:shore_app/screens/FollowersScreen.dart';
import 'package:shore_app/screens/FollowingsScreen.dart';
import 'package:shore_app/screens/HomeScreen.dart';
import 'package:shore_app/screens/LikedPosts.dart';
import 'package:shore_app/screens/MessageClicked.dart';
import 'package:shore_app/screens/NewPostScreen.dart';
import 'package:shore_app/screens/PostEditScreen.dart';
import 'package:shore_app/screens/SearchScreen.dart';
import 'package:shore_app/screens/SettingScreen.dart';
import 'package:shore_app/screens/UnsignUserPostListScreen.dart';
import 'package:shore_app/screens/UserPostListScreen.dart';
import 'package:shore_app/screens/UserScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final FirebaseApp app;
late final FirebaseAuth auth;
late String token;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: "6LeDK7slAAAAAA1wfDN9f8AB5d7sJINwuD6MDPcG1",
    androidProvider: AndroidProvider.playIntegrity,
  );

  auth = await FirebaseAuth.instanceFor(app: app);

  var value = await FirebaseMessaging.instance.getToken();

  await Prefs.init();

  Client client = Client();
  final res = await client.post(
    Uri.parse("https://shore.vercel.app/api/get-api"),
  );

  final parsedBody = json.decode(res.body);

  Prefs.prefs.setString("shore_device_token", value!);
  Prefs.prefs.setString("shore_backend_uri", parsedBody["api_uri"]);
  // prefs.setString("shore_backend_uri", "http://192.168.1.42:3000");
  // prefs.setString("shore_backend_socket_uri", "http://192.168.1.37:4000");

  print("FCM Token: $value");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    // Provider.of<SignUser>(navigatorKey.currentState!.context, listen: false)
    // .addMessage(message.data);
  });

//Application in Background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
    if (message != null) {
      print('Message clicked: ${message.data}');
      // Provider.of<SignUser>(navigatorKey.currentState!.context, listen: false)
      //     .addMessage(message.data);
      Navigator.of(navigatorKey.currentState!.context)
          .popUntil((route) => route == HomeScreen.routeName);
      Navigator.of(navigatorKey.currentState!.context)
          .pushNamed(HomeScreen.routeName);
      if (message.data["for"] == "messaging")
        Navigator.of(
          navigatorKey.currentState!.context,
        ).pushNamed(ChatScreen.routeName,
            arguments: message.data["senderUserId"]);
      else if (message.data["for"] == "follow") {
        var user = await Provider.of<UnsignUser>(
                navigatorKey.currentState!.context,
                listen: false)
            .reloadUser(message.data["userId"]);
        Navigator.of(
          navigatorKey.currentState!.context,
        ).pushNamed(UserScreen.routeName, arguments: user);
      } else if (message.data["for"] == "comment")
        Navigator.of(
          navigatorKey.currentState!.context,
        ).pushNamed(CommentScreen.routeName, arguments: message.data["postId"]);
    } else {
      print("Message is null");
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  if (message != null) {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.data}");
    // Navigator.of(navigatorKey.currentState!.context)
    //     .popUntil((route) => route == HomeScreen.routeName);
    Navigator.of(navigatorKey.currentState!.context)
        .pushNamed(HomeScreen.routeName);
    if (message.data["for"] == "messaging")
      Navigator.of(
        navigatorKey.currentState!.context,
      ).pushNamed(ChatScreen.routeName,
          arguments: message.data["senderUserId"]);
    else if (message.data["for"] == "follow") {
      var user = await Provider.of<UnsignUser>(
              navigatorKey.currentState!.context,
              listen: false)
          .reloadUser(message.data["userId"]);
      Navigator.of(
        navigatorKey.currentState!.context,
      ).pushNamed(UserScreen.routeName, arguments: user);
    } else if (message.data["for"] == "comment")
      Navigator.of(
        navigatorKey.currentState!.context,
      ).pushNamed(CommentScreen.routeName, arguments: message.data["postId"]);
  } else {
    print("Message is null");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppSetting()),
        ChangeNotifierProvider.value(value: SignUser()),
        ChangeNotifierProvider.value(value: UnsignUser()),
        ChangeNotifierProvider.value(value: Posts()),
      ],
      child: MaterialApp(
        
        title: 'MTrace',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 0, 190, 184),
          ),
        ),
        // home: const HomeScreen(),
        navigatorKey: navigatorKey,
        home: AuthScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          PostEditScreen.routeName: (ctx) => PostEditScreen(),
          NewPostScreen.routeName: (ctx) => const NewPostScreen(),
          UserPostListScreen.routeName: (ctx) => UserPostListScreen(),
          UnsignUserPostListScreen.routeName: (ctx) =>
              UnsignUserPostListScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
          UserScreen.routeName: (ctx) => UserScreen(),
          FollowersScreen.routeName: (ctx) => FollowersScreen(),
          FollowingsScreen.routeName: (ctx) => FollowingsScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          SettingScreen.routeName: (ctx) => const SettingScreen(),
          MessageClicked.routeName: (ctx) => const MessageClicked(),
          CommentScreen.routeName: (ctx) => CommentScreen(),
          LikedPostsScreen.routeName: (ctx) => LikedPostsScreen(),
        },
      ),
    );
  }
}
