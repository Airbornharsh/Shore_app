import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shore_app/Components/Upload.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromARGB(31, 121, 121, 121)),
          height: MediaQuery.of(context).size.height - 130,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Upload()
            ],
          ),
        ),
      ),
    );
  }
}
