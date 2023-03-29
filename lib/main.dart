import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/firebase_options.dart';
import 'package:shore_app/provider/AppSetting.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/UnsignUser.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/ChatScreen.dart';
import 'package:shore_app/screens/EditProfileScreen.dart';
import 'package:shore_app/screens/FollowersScreen.dart';
import 'package:shore_app/screens/FollowingsScreen.dart';
import 'package:shore_app/screens/HomeScreen.dart';
import 'package:shore_app/screens/NewPostScreen.dart';
import 'package:shore_app/screens/PostEditScreen.dart';
import 'package:shore_app/screens/SearchScreen.dart';
import 'package:shore_app/screens/SettingScreen.dart';
import 'package:shore_app/screens/UserPostListScreen.dart';
import 'package:shore_app/screens/UserScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppSetting()),
        ChangeNotifierProvider.value(value: User()),
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
        home: HomeScreen(),
        routes: {
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
          PostEditScreen.routeName: (ctx) => PostEditScreen(),
          NewPostScreen.routeName: (ctx) => const NewPostScreen(),
          UserPostListScreen.routeName: (ctx) => UserPostListScreen(),
          SearchScreen.routeName: (ctx) => const SearchScreen(),
          UserScreen.routeName: (ctx) => UserScreen(),
          FollowersScreen.routeName: (ctx) => FollowersScreen(),
          FollowingsScreen.routeName: (ctx) => FollowingsScreen(),
          ChatScreen.routeName: (ctx) =>  ChatScreen(),
          SettingScreen.routeName: (ctx) => const SettingScreen(),
        },
      ),
    );
  }
}
