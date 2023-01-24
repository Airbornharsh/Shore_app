import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class PostEditScreen extends StatefulWidget {
  static String routeName = "/edit-post";
  const PostEditScreen({super.key});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  bool isFile = false;
  late File tempFile;

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

    return Scaffold(
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

                      isFile = true;
                      String path = result.files[0].path as String;

                      File? compressedFile =
                          await FlutterNativeImage.compressImage(path,
                              quality: 30, percentage: 30);

                      setState(() {
                        tempFile = compressedFile;
                      });
                    } catch (e) {
                      print(e);
                      isFile = false;
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isFile
                              ? Image.file(
                                  tempFile,
                                  height: 400,
                                  fit: BoxFit.contain,
                                )
                              : (post.url.isNotEmpty
                                  ? Image.network(
                                      post.url,
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      filterQuality: FilterQuality.low,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  padding: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 0, 190, 184))),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _descriptionController,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // try {
                    //   final user =
                    //       Provider.of<User>(context, listen: false).getUserDetails;
                    //   final fileName = isFile
                    //       ? "${tempFile.path.split('/').last}_${DateTime.now().toString()}"
                    //       : "";
                    //   final destination = "profile/${user.id}/$fileName";

                    //   String res = isFile
                    //       ? await Provider.of<User>(context, listen: false)
                    //           .editProfileWithImg(
                    //           file: tempFile,
                    //           fileName: fileName,
                    //           destination: destination,
                    //           name: _nameController.text,
                    //           gender: _genderController.text,
                    //           userName: _userNameController.text,
                    //           emailId: _emailIdController.text,
                    //           phoneNumber: _phoneNumberController.text,
                    //         )
                    //       : await Provider.of<User>(context, listen: false)
                    //           .editProfile(
                    //           name: _nameController.text,
                    //           gender: _genderController.text,
                    //           userName: _userNameController.text,
                    //           emailId: _emailIdController.text,
                    //           phoneNumber: _phoneNumberController.text,
                    //         );

                    //   if (res == "withImg") {
                    //     snackBar(context, "Updated");
                    //     _nameController.text = "";
                    //     _genderController.text = "";
                    //     _userNameController.text = "";
                    //     _emailIdController.text = "";
                    //     _phoneNumberController.text = "";
                    //     setState(() {
                    //       // _descriptionController.clear();
                    //       isFile = true;
                    //     });
                    //   } else if (res == "withoutImg") {
                    //     snackBar(context, "Updated");
                    //     _nameController.text = "";
                    //     _genderController.text = "";
                    //     _userNameController.text = "";
                    //     _emailIdController.text = "";
                    //     _phoneNumberController.text = "";
                    //   } else {
                    //     snackBar(context, "Try Again");
                    //   }
                    // } catch (e) {
                    //   snackBar(context, "Try Again");
                    //   print(e);
                    // }
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
            ),
          ),
        ));
  }
}
