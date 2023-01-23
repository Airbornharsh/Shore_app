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
  bool isFile = false;
  late File tempFile;
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
        tempFile = File(user.imgUrl.isNotEmpty
            ? user.imgUrl
            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
      });

      widget.start = 0;
    }

    return Scaffold(
      appBar: AppBar(title: Text(user.userName)),
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
                      .pickFiles(type: FileType.image, allowMultiple: false);

                  if (result == null) return;

                  isFile = true;
                  String path = result.files[0].path as String;

                  File? compressedFile = await FlutterNativeImage.compressImage(
                      path,
                      quality: 10,
                      percentage: 20);

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
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              user.imgUrl.isNotEmpty
                                  ? user.imgUrl
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  final user =
                      Provider.of<User>(context, listen: false).getUserDetails;
                  final fileName = isFile
                      ? "${tempFile.path.split('/').last}_${DateTime.now().toString()}"
                      : "";
                  final destination = "profile/${user.id}/$fileName";

                  String res = isFile
                      ? await Provider.of<User>(context, listen: false)
                          .editProfileWithImg(
                          file: tempFile,
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

                  if (res == "withImg") {
                    snackBar(context, "Updated");
                    _nameController.text = "";
                    _genderController.text = "";
                    _userNameController.text = "";
                    _emailIdController.text = "";
                    _phoneNumberController.text = "";
                    setState(() {
                      // _descriptionController.clear();
                      isFile = true;
                    });
                  } else if (res == "withoutImg") {
                    snackBar(context, "Updated");
                    _nameController.text = "";
                    _genderController.text = "";
                    _userNameController.text = "";
                    _emailIdController.text = "";
                    _phoneNumberController.text = "";
                  } else {
                    snackBar(context, "Try Again");
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
        ),
      )),
    );
  }
}
