import "dart:io";
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/provider/Posts.dart';
import 'package:shore_app/provider/User.dart';
import 'package:video_player/video_player.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  late File tempFile;
  String isFile = "";
  late VideoPlayerController _controller;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose(); // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      height: isFile == "image" ? 350 : 140,
      padding: const EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (isFile == "image")
            Image.file(
              tempFile,
              height: 190,
            ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.9, color: Colors.black45)),
                width: MediaQuery.of(context).size.width - 140,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
              ),
              Container(
                height: 45,
                width: 82,
                color: const Color.fromARGB(255, 1, 214, 207),
                child: TextButton(
                  onPressed: () async {
                    try {
                      final user = Provider.of<User>(context, listen: false)
                          .getUserDetails;
                      final fileName =
                          "${tempFile.path.split('/').last}_${DateTime.now().toString()}";
                      final destination = "files/${user.id}/$fileName";

                      bool res = await Provider.of<User>(context, listen: false)
                          .postUpload(tempFile, _descriptionController.text,
                              fileName, destination);

                      if (res) {
                        snackBar(context, "Post Uploaded");
                        setState(() {
                          _descriptionController.clear();
                          isFile = "";
                        });
                      } else {
                        snackBar(context, "Try Again");
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 1, 214, 207)),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  try {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: false);

                    if (result == null) return;

                    isFile = "image";
                    String path = result.files[0].path as String;

                    File? compressedFile =
                        await FlutterNativeImage.compressImage(
                      path,
                      quality: 30,
                      percentage: 30,
                    );

                    setState(() {
                      tempFile = compressedFile;
                    });
                  } catch (e) {
                    print(e);
                    isFile = "";
                  }
                },
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
                onTap: () async {
                  try {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.video, allowMultiple: false);

                    if (result == null) return;

                    setState(() {
                      isFile = "video";
                      final path = result.files[0].path;

                      tempFile = File(path as String);

                      _controller = VideoPlayerController.file(tempFile);
                    });
                  } catch (e) {
                    print(e);
                    isFile = "";
                  }
                },
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
    );
  }
}
