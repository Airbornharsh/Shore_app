import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class PostEditScreen extends StatefulWidget {
  static String routeName = "/edit-post";
  PostEditScreen({super.key});
  int start = 1;

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  bool _isFile = false;
  late File _tempFile;
  bool _isLoading = false;

  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserPostModel post =
        ModalRoute.of(context)?.settings.arguments as UserPostModel;

    if (widget.start == 1) {
      _descriptionController.text = post.description;
      widget.start = 0;
    }

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text("Edit Post"),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.image, allowMultiple: false);

                          if (result == null) return;

                          _isFile = true;
                          String path = result.files[0].path as String;

                          final fileHeight = (await decodeImageFromList(
                                  (File(path)).readAsBytesSync()))
                              .height;
                          final fileWidth = (await decodeImageFromList(
                                  (File(path)).readAsBytesSync()))
                              .width;

                          final compressedtargetwidth =
                              (400 / fileHeight) * fileWidth;

                          File? compressedFile =
                              400 / compressedtargetwidth != 4 / 3
                                  ? await FlutterNativeImage.compressImage(path,
                                      quality: 40,
                                      targetHeight: 400 * 2,
                                      targetWidth:
                                          compressedtargetwidth.toInt() * 2)
                                  : await FlutterNativeImage.compressImage(path,
                                      quality: 40,
                                      targetHeight:
                                          compressedtargetwidth.toInt() * 2,
                                      targetWidth: 400 * 2);

                          setState(() {
                            _tempFile = compressedFile;
                          });
                        } catch (e) {
                          print(e);
                          _isFile = false;
                        }
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                              child: _isFile
                                  ? Image.file(
                                      _tempFile,
                                      height: 400,
                                      fit: BoxFit.contain,
                                    )
                                  : (post.url.isNotEmpty
                                      ? Hero(
                                          tag: post.id,
                                          child: Image.network(post.url,
                                              height: 400,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              filterQuality: FilterQuality.low,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                            return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 400,
                                                decoration: BoxDecoration(),
                                                child: Center(
                                                    child: Image.asset(
                                                        "lib/assets/images/error.png")));
                                          }),
                                        )
                                      : null)),
                          const Positioned(
                            right: 0,
                            child: Icon(Icons.edit, size: 17),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      padding: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 0, 190, 184))),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        controller: _descriptionController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TextButton(
                        //   onPressed: () async {
                        //     try {
                        //       setState(() {
                        //         _isLoading = true;
                        //       });

                        //       final user =
                        //           Provider.of<User>(context, listen: false)
                        //               .getUserDetails;
                        //       final random1 =
                        //           (Random()).nextInt(99999).toString();
                        //       final random2 =
                        //           (Random()).nextInt(99999).toString();
                        //       final fileName =
                        //           "${_tempFile.path.split('/').last}_${random1 + random2}";
                        //       final destination = "files/${user.id}/$fileName";

                        //       String res = _isFile
                        //           ? await Provider.of<User>(
                        //                   context,
                        //                   listen: false)
                        //               .editPostWithImg(
                        //                   file: _tempFile,
                        //                   fileName: fileName,
                        //                   destination: destination,
                        //                   description:
                        //                       _descriptionController.text,
                        //                   post: post)
                        //           : await Provider.of<User>(context,
                        //                   listen: false)
                        //               .editPost(
                        //                   description:
                        //                       _descriptionController.text,
                        //                   post: post);

                        //       setState(() {
                        //         _isLoading = false;
                        //       });

                        //       if (res == "withImg") {
                        //         snackBar(context, "Updated");
                        //         _descriptionController.clear();
                        //         setState(() {
                        //           // _descriptionController.clear();
                        //           _isFile = true;
                        //         });
                        //       } else if (res == "withoutImg") {
                        //         snackBar(context, "Updated");
                        //         _descriptionController.clear();
                        //       } else {
                        //         snackBar(context, res);
                        //       }
                        //     } catch (e) {
                        //       snackBar(context, "Try Again");
                        //       print(e);
                        //     }
                        //   },
                        //   style: ButtonStyle(
                        //       backgroundColor: MaterialStateProperty.all<Color>(
                        //           Colors.red.shade600)),
                        //   child: const Text(
                        //     "Delete",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   width: 14,
                        // ),
                        TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              String res = await Provider.of<User>(context,
                                      listen: false)
                                  .deletePost(
                                      description: _descriptionController.text,
                                      post: post);

                              setState(() {
                                _isLoading = false;
                              });

                              if (res == "withImg") {
                                snackBar(context, "Updated");
                                _descriptionController.clear();
                                setState(() {
                                  // _descriptionController.clear();
                                  _isFile = true;
                                });
                              } else if (res == "withoutImg") {
                                snackBar(context, "Updated");
                                _descriptionController.clear();
                              } else {
                                snackBar(context, res);
                              }
                            } catch (e) {
                              snackBar(context, "Try Again");
                              print(e);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 0, 190, 184))),
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
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
