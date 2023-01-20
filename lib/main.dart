import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/firebase_options.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:shore_app/screens/AuthScreen.dart';
import 'package:shore_app/screens/HomeScreen.dart';
import 'package:video_player/video_player.dart';

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
        ChangeNotifierProvider.value(value: User()),
        ChangeNotifierProvider.value(value: Posts()),
        // ChangeNotifierProvider.value(value: Expenses()),
        // ChangeNotifierProvider.value(value: OfflineExpenses()),
      ],
      child: MaterialApp(
        title: 'MTrace',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(255, 0, 190, 184),
          ),
        ),
        // home: const HomeScreen(),
        home: const HomeScreen(),
        routes: {AuthScreen.routeName: (ctx) => AuthScreen()},
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late FilePickerResult tempFile;
//   String isFile = "";

//   // final storage = FirebaseStorage.instance.ref();

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           if (isFile == "image")
//             Image.file(File(tempFile.files[0].path as String),
//                 width: MediaQuery.of(context).size.width - 20,
//                 height: 300,
//                 fit: BoxFit.contain),
//           if (isFile == "video")
//             VideoPlayer(VideoPlayerController.file(
//                 File(tempFile.files[0].path as String))),
//           TextButton(
//               onPressed: () async {
//                 try {
//                   FilePickerResult? result = await FilePicker.platform
//                       .pickFiles(type: FileType.image, allowMultiple: false);

//                   setState(() {
//                     if (["jpg", "jpeg", "png", "svg"]
//                         .contains(result?.files[0].extension)) {
//                       isFile = "image";
//                       tempFile = result!;
//                     } else if (["mp4", "mkv"]
//                         .contains(result?.files[0].extension)) {
//                       isFile = "video";
//                       tempFile = result!;
//                     }
//                   });

//                   if (result != null) {
//                     // File file = File()
//                     // print(result.files[0].path);
//                   } else {
//                     // User canceled the picker
//                   }
//                 } catch (e) {
//                   print(e);
//                 }
//               },
//               child: const Text("Select File ")),
//         ],
//       )), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
