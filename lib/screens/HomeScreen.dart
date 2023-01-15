import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                height: 140,
                padding: const EdgeInsets.only(
                    top: 10, right: 20, bottom: 10, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.9, color: Colors.black45)),
                          width: MediaQuery.of(context).size.width - 140,
                          child: const TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 82,
                          color: const Color.fromARGB(255, 1, 214, 207),
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 1, 214, 207)),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                            child: const Text(
                              "Post",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(children: const [
                            Icon(
                              Icons.photo,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Photo",
                              style: TextStyle(color: Colors.black54),
                            )
                          ]),
                        ),
                        Container(
                          width: 1.5,
                          color: Colors.black38,
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(children: const [
                            Icon(
                              Icons.video_collection_rounded,
                              color: Colors.greenAccent,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Video",
                              style: TextStyle(color: Colors.black54),
                            )
                          ]),
                        ),
                        Container(
                          width: 1.5,
                          color: Colors.black38,
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(children: const [
                            Icon(
                              Icons.photo,
                              color: Colors.orange,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "File",
                              style: TextStyle(color: Colors.black54),
                            )
                          ]),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
