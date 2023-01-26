import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Utils/snackBar.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/User.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/edit-profile";
  EditProfileScreen({super.key});
  var start = 1;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isFile = false;
  late File _tempFile;
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _nameController.dispose();
    _genderController.dispose();
    _emailIdController.dispose();
    _userNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<User>(context).getUserDetails;

    if (widget.start == 1) {
      _nameController.text = user.name;
      _genderController.text = user.gender;
      _userNameController.text = user.userName;
      _emailIdController.text = user.emailId;
      _phoneNumberController.text = user.phoneNumber;
      setState(() {
        _tempFile = File(user.imgUrl.isNotEmpty
            ? user.imgUrl
            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
      });

      widget.start = 0;
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(user.userName),
          ),
          body: SingleChildScrollView(
              child: SizedBox(
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

                      File? compressedFile =
                          await FlutterNativeImage.compressImage(path,
                              quality: 20, percentage: 30);

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
                          borderRadius: BorderRadius.circular(10),
                          child: _isFile
                              ? Image.file(
                                  _tempFile,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                )
                              : Hero(
                                  tag: user.id,
                                  child: Image.network(
                                      user.imgUrl.isNotEmpty
                                          ? user.imgUrl
                                          : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                    return Container(
                                        width: 90,
                                        height: 90,
                                        child: Center(
                                            child: Image.asset(
                                                "lib/assets/images/error.png")));
                                  }),
                                )),
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
                    controller: _nameController,
                  ),
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
                      hintText: "Gender",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _genderController,
                  ),
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
                      hintText: "User Name",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _userNameController,
                  ),
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
                      hintText: "Email Id",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _emailIdController,
                  ),
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
                      hintText: "Phone Number",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _phoneNumberController,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });

                      final user = Provider.of<User>(context, listen: false)
                          .getUserDetails;
                      final random1 = (Random()).nextInt(99999).toString();
                      final random2 = (Random()).nextInt(99999).toString();
                      final fileName =
                          "${_tempFile.path.split('/').last}_${random1 + random2}";
                      final destination = "profile/${user.id}/$fileName";

                      String res = _isFile
                          ? await Provider.of<User>(context, listen: false)
                              .editProfileWithImg(
                              file: _tempFile,
                              fileName: fileName,
                              destination: destination,
                              name: _nameController.text,
                              gender: _genderController.text,
                              userName: _userNameController.text,
                              emailId: _emailIdController.text,
                              phoneNumber: _phoneNumberController.text,
                            )
                          : await Provider.of<User>(context, listen: false)
                              .editProfile(
                              name: _nameController.text,
                              gender: _genderController.text,
                              userName: _userNameController.text,
                              emailId: _emailIdController.text,
                              phoneNumber: _phoneNumberController.text,
                            );

                      setState(() {
                        _isLoading = false;
                      });
                      if (res == "withImg") {
                        snackBar(context, "Updated");
                        _nameController.clear();
                        _genderController.clear();
                        _userNameController.clear();
                        _emailIdController.clear();
                        _phoneNumberController.clear();
                        setState(() {
                          // _descriptionController.clear();
                          _isFile = true;
                        });
                      } else if (res == "withoutImg") {
                        snackBar(context, "Updated");
                        _nameController.clear();
                        _genderController.clear();
                        _userNameController.clear();
                        _emailIdController.clear();
                        _phoneNumberController.clear();
                      } else {
                        snackBar(context, "Try Again");
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
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
            ),
          )),
        ),
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
